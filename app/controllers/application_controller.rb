class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # EN: Helper used FROM Engine: Decision Maps:
  # ES: Helper usado DESDE el Engine: Mapas de Decision
  helper Mapas::SharedHelper

  # EN: Helper used FROM Engine: Assessment Scenarios:
  # ES: Helper usado DESDE el Engine: Escenarios de Evaluacion
  helper Escenarios::SharedHelper

  # EN: Methods used TOWARDS Engine: Cuantification:
  # ES: Metodos usados HACIA el Engine: Cuantificacion
  # --------------------------------------------------

  # EN: Cuantification:: Method to get the cuantification's enterprise from the user session
  # ES: Cuantificacion:: Metodo para obtener la empresa del modulo de cuantificacion desde la sesion del usuario
  def getMyEnterpriseQUANT
    return view_context.getMyQuantEnterprise
  end

  # EN: Cuantification:: Method to generate a normal distribution given a confidence interval
  # ES: Cuantificacion:: Metodo para generar una distribucion normal dado un intervalo de confianza
  def normalDistributionPValue(confidence)
    return Distribution::Normal.p_value(confidence)
  end

  # EN: Cuantification:: Method to generate a normal distribution and its cumulative distribution function
  # ES: Cuantificacion:: Metodo para generar una distribucion normal y su funcion de distribucion acumulada CDF
  def normalDistributionCDF(value)
    return Distribution::Normal.cdf(value)
  end

  # -------------------------------------------------


  # ES: Metodos usados HACIA los demas engines (3) de manera transversal:
  # EN: Methods used TOWARDS the rest of engines (3) in a transversal way:
  # -------------------------------------------------------------

  # ES: Transversal:: Metodo para obtener la empresa principal en la sesion del usuario
  # EN: Tranversal:: Method to get the main enterprise from the user session
  def getMyEnterpriseAPP
  	return view_context.getMyEnterprise
  end

  # ES: Transversal:: Metodo que lista las estructuras de gobierno de una empresa dada
  # EN: Transversal:: Method that list the governance structures of a given enterprise
  def getStructuresAPP
    emp = view_context.getMyEnterprise
    ests = GovernanceStructure.where(enterprise_id: emp.id)
    return ests
  end

  # -------------------------------------------------------------


  # ES: Metodos usados HACIA el engine de Escenarios de Evaluacion:
  # EN: Methods used TOWARDS Engine: Assessment Scenarios
  # -------------------------------------------------------------

  # ES: Escenarios:: Metodo que lista los Mapas de decision con riesgos asociados de una empresa dada
  # EN: Scenarios:: Method that list the Decision Maps with related risks of a given enterprise
  def getRiskedDecisionMaps
    emp = view_context.getMyEnterprise
    # ES: Obtiene los mapas de decision de la empresa tratada:
    # EN: Get the decision maps of the enterprise
    idsMapas = Mapas::DecisionMap.where(enterprise_id: emp.id).pluck(:id)
    # ES: Elimina del tratamiento, los mapas que ya tienen un escenario de evaluacion asociado:
    # EN: Remove from the treatment, the maps that already have related an assessment scenario:
    idsMapasYaAsociados = Escenarios::RiskEscenario.where(decision_map_id: idsMapas).pluck(:decision_map_id)
    idsMapas = idsMapas - idsMapasYaAsociados
    # ES: Obtiene todos los hallazgos asociados a dichos mapas:
    # EN: Get all the findings related to those maps
    finds = Mapas::Finding.where(decision_map_id: idsMapas)
    # ES: Filtra los hallazgos que tienen riesgos asociados:
    # EN: Filters the findings that have related risks: 
    finds = finds.select{|f| !f.parsed_risks.nil?}
    # ES: Obtiene los ids filtrados de los mapas de decision
    # EN: Get the filtered ids of the decision maps
    idsMapas = finds.map{|f| f.decision_map_id}.uniq
    # ES: Obtiene los mapas filtrados, cuyos hallazgos tienen riesgos asociados:
    # EN: Get the filtered maps, whose findings have associated risks
    mapas = Mapas::DecisionMap.where(id: idsMapas)
    # ES: Por cada mapa, obtiene los ids de los riesgos asociados, para enviarlos de una vez tambien
    # EN: For each map, get the ids of the relaed risks, to send them at once
    arrayIdsRiesgos = [] # ES: Arreglo de arreglos - EN: Array of arrays
    mapas.each do |m|
      idsRiesgos = []
      # ES: Obtiene los hallazgos de dicho mapa:
      # EN: Get the findings of that map
      finds = Mapas::Finding.where(decision_map_id: m.id).select{|f| !f.parsed_risks.nil? }
      # ES: De cada hallazgo con riesgos, va obteniendo sus ids:
      # EN: For each finding with risks, get its ids
      finds.each do |f|
        idsTemp = f.parsed_risks.split("|")
        restoredArray = idsTemp.map {|id| id.to_i}
        idsRiesgos.concat(restoredArray)
      end
      # ES: Elimina los repetidos y lo agrega al arreglo de arreglos:
      # ES: Remove the repeated ones, and add them to the array of arrays
      idsRiesgos.uniq!
      arrayIdsRiesgos.push(idsRiesgos)
    end

    # ES: Regresa un arreglo con 2 arreglos: mapas y sus riesgos asociados
    # EN: Returns an array with 2 arrays: maps and its related risks
    return [mapas, arrayIdsRiesgos]
  end  
  # ----------->

  # ES: Escenarios:: Metodo que crea un escenario de evaluacion de riesgos a partir de un mapa de decision (con sus riesgos asociados)
  # EN: Scenarios:: Method that creates a risk assessment scenario from a decision map (with its realted risks)
  def importRiskEscenarioFromDecisionMap(idMap)
    mapa = Mapas::DecisionMap.find(idMap)
    # ES: Return TRUE: Si la creacion y asociacion fue exitosa
    #            FALSE: Si hubo algun inconveniente creando el escenario de evaluacion de riesgos
    # EN: Return TRUE: If the creation and association were succesful
    #            FALSE: If a problem was presented creating the risk assessment scenario
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

  # ES: Escenarios:: Metodo que dado un escenario de evaluacion generado, da sus riesgos asociados (restringidos por la info. de los hallazgos)
  # EN: Scenarios:: Method that given a generated risk assessment scenario, get its related risks (restricted by the findings' info)
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
