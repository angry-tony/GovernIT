class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Helper usado DESDE el engine de Mapas de Decision:
  helper Mapas::SharedHelper

  # Helper usado DESDE el engine de Escenarios de Evaluacion:
  helper Escenarios::SharedHelper

  # Metodos usados HACIA el engine de Cuantificacion:
  # --------------------------------------------------

  # Cuantificacion:: Metodo para obtener la empresa de cuantificacion en la sesion del usuario
  def getMyEnterpriseQUANT
    return view_context.getMyQuantEnterprise
  end

  # Cuantificacion:: Metodo para generar una distribucion normal dado un intervalo de confianza
  def normalDistributionPValue(confidence)
    return Distribution::Normal.p_value(confidence)
  end

  # Cuantificacion:: Metodo para generar una distribucion normal y su funcion de distribucion acumulada CDF
  def normalDistributionCDF(value)
    return Distribution::Normal.cdf(value)
  end

  # -------------------------------------------------


  # Metodos usados HACIA los demas engines (3) de manera transversal:
  # -------------------------------------------------------------

  # Transversal:: Metodo para obtener la empresa principal en la sesion del usuario
  def getMyEnterpriseAPP
  	return view_context.getMyEnterprise
  end

  # Transversal:: Metodo que lista las estructuras de gobierno de una empresa dada
  def getStructuresAPP
    emp = view_context.getMyEnterprise
    ests = GovernanceStructure.where(enterprise_id: emp.id)
    return ests
  end

  # -------------------------------------------------------------


  # Metodos usados HACIA el engine de Escenarios de Evaluacion:
  # -------------------------------------------------------------

  # Escenarios:: Metodo que lista los Mapas de decision con riesgos asociados de una empresa dada
  def getRiskedDecisionMaps
    emp = view_context.getMyEnterprise
    # Obtiene los mapas de decision de la empresa tratada:
    idsMapas = Mapas::DecisionMap.where(enterprise_id: emp.id).pluck(:id)
    # Elimina del tratamiento, los mapas que ya tienen un escenario de evaluacion asociado:
    idsMapasYaAsociados = Escenarios::RiskEscenario.where(decision_map_id: idsMapas).pluck(:decision_map_id)
    idsMapas = idsMapas - idsMapasYaAsociados
    # Obtiene todos los hallzagos asociados a dichos mapas:
    finds = Mapas::Finding.where(decision_map_id: idsMapas)
    # Filtra los hallazgos que tienen riesgos asociados:
    finds = finds.select{|f| !f.parsed_risks.nil?}
    # Obtiene los ids filtrados de los mapas de decision
    idsMapas = finds.map{|f| f.decision_map_id}.uniq
    # Obtiene los mapas filtrados, cuyos hallazgos tienen riesgos asociados:
    mapas = Mapas::DecisionMap.where(id: idsMapas)
    # Por cada mapa, obtiene los ids de los riesgos asociados, para enviarlos de una vez tambien
    arrayIdsRiesgos = [] # Arreglo de arreglos
    mapas.each do |m|
      idsRiesgos = []
      # Obtiene los hallazgos de dicho mapa:
      finds = Mapas::Finding.where(decision_map_id: m.id).select{|f| !f.parsed_risks.nil? }
      # De cada hallazgo con riesgos, va obteniendo sus ids:
      finds.each do |f|
        idsTemp = f.parsed_risks.split("|")
        restoredArray = idsTemp.map {|id| id.to_i}
        idsRiesgos.concat(restoredArray)
      end
      # Elimina los repetidos y lo agrega al arreglo de arreglos:
      idsRiesgos.uniq!
      arrayIdsRiesgos.push(idsRiesgos)
    end

    # Regresa un arreglo con 2 arreglos: mapas y sus riesgos asociados
    return [mapas, arrayIdsRiesgos]
  end  
  # ----------->

  # Escenarios:: Metodo que crea un escenario de evaluacion de riesgos a partir de un mapa de decision (con sus riesgos asociados)
  def importRiskEscenarioFromDecisionMap(idMap)
    mapa = Mapas::DecisionMap.find(idMap)
    # Return TRUE: Si la creacion y asociacion fue exitosa
    #        FALSE: Si hubo algun inconveniente creando el escenario de evaluacion de riesgos
    riskEsc = Escenarios::RiskEscenario.new
    riskEsc.name = 'Risk related to the Decision Map: ' << mapa.name
    riskEsc.enterprise_id = view_context.getMyEnterprise.id
    riskEsc.decision_map_id = idMap
    if riskEsc.save
      true
    else
      false
    end
  end
  # ----------->

  # Escenarios:: Metodo que dado un escenario de evaluacion generado, da sus riesgos asociados (restringidos por la info. de los hallazgos)
  def getRisksFromDecisionMap(idMap)
    findings = Mapas::Finding.where("decision_map_id = ?", idMap).select{|f| !f.parsed_risks.blank?}
    parsedRisks = []
    findings.each do |fi|
      parsed = fi.parsed_risks
      partes = parsed.split("|")
      partes.each do |p|
        parsedRisks.push(p)
      end
    end

    parsedRisks.uniq!
    parsedRisks.sort!

    risks = Risk.where(nivel: 'GENERICO', id: parsedRisks).order(id: :asc)
    return risks
  end
  # ------------>





  
end
