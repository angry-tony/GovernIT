#encoding: utf-8

require_dependency "mapas/application_controller"

module Mapas
  class GovernanceController < ApplicationController

  	include SharedHelper

  	# Decisiones:
  	def decisions
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
			@dims = [DIM_DEC_1, DIM_DEC_2, DIM_DEC_3, DIM_DEC_4, DIM_DEC_5, DIM_DEC_6]
			# Envia las genericas ordenadas por dimension, para realizar el agrupamiento
			@genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, @empresa.id).order(dimension: :asc)
			# Envia las especificas ordenadas por su padre, para realizar el agrupamiento:
		    @genericas.size == 0 ? @tieneDecisiones = false : @tieneDecisiones = true
		    @especificas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id).order(parent_id: :asc)
		else
			redirect_to main_app.root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu'
		end
	end
	# ----------- Decisiones


	# Agregar decisiones especificas via AJAX:
	def add_specific
		@empresa = getMyEnterpriseAPP
		padre = GovernanceDecision.find(params[:id_padre].to_i)
		# Parametros para construir la decision:
		desc = params[:description]
		dim = padre.dimension
		# Crea la decision:
		decSpe = GovernanceDecision.new
		decSpe.description = desc
		decSpe.dimension = padre.dimension
		decSpe.decision_type = SPECIFIC_TYPE
		decSpe.parent_id = padre.id
		decSpe.enterprise_id = @empresa.id

		respond_to do |format|
			if decSpe.save
				# Todo OK
				format.json {render json: decSpe}
			else
				# No se pudo guardar
				format.json {render json: 'ERROR'}
			end
			
        end
	end
	# ------------

	# Agregar decisiones genericas via AJAX:
	def add_generic
		emp = getMyEnterpriseAPP
		dim = params[:dimension]
		# La dimension puede venir en español o en ingles, verifica y ajusta (En la BD SIEMPRE EN ESPAÑOL!)
		if !I18n.default_locale.to_s.eql?("es")
			# Viene en ingles, debe pasarla a español:
			dim = view_context.translateDimensionToES(dim)
		end
		
		desc = params[:description]
		# Crea una decision generica:
		decGen = GovernanceDecision.new
		decGen.description = desc
		decGen.dimension = dim
		decGen.decision_type = GENERIC_TYPE
		decGen.enterprise_id = emp.id

		respond_to do |format|
			if decGen.save
				# Todo OK
				format.json {render json: decGen}
			else
				# No se pudo guardar
				format.json {render json: 'ERROR'}
			end
			
        end	
	end
	# ---------

	def decision_maps
		@empresa = getMyEnterpriseAPP
		if !@empresa.nil?
			@maps = DecisionMap.where("enterprise_id = ?", @empresa.id)
			@ests = GovernanceStructure.where("enterprise_id = ?", @empresa.id)
		else
			redirect_to main_app.root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu'
		end
	end
	# -------------


	def add_map
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		desc = params[:desc]
		est = params[:est]
		type = params[:type]

		map = DecisionMap.new
		map.name = name
		map.description = desc
		map.map_type = type
		map.enterprise_id = @empresa.id
		map.governance_structure_id = est.to_i

		respond_to do |format|
        	if map.save # OK
        		format.json {render json: map}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end
	# ------------------

	def decision_map
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
		    @estructuras = GovernanceStructure.where("enterprise_id = ?", @empresa.id).order(id: :asc)
			@genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, @empresa.id).order(dimension: :asc)

			# Según el tipo de mapa, lo redirige:
			@map = DecisionMap.find(params[:idMap].to_i)
			@details = @map.map_details

			if @map.map_type.nil?
				# Es nulo, aprovecha para actualizar su valor a mapa de arquetipos:
				@map.map_type = MAP_TYPE_1
				@map.save
				# Redirige a su propio render, cargando los arquetipos apropiados
				@archs = DecisionArchetype.all

		    else
		    	# Mapa de arquetipos:
		    	# Redirige a su propio render, cargando los arquetipos apropiados
				@archs = DecisionArchetype.all
			end

		end
		
	end
	# -----------

	def decision_map_2
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
		    @estructuras = GovernanceStructure.where("enterprise_id = ?", @empresa.id).order(id: :asc)
		    
		    # Temporal: Se crearon 2 estructuras ficticias para modelar los valores "No aplica" y "No existe"
		    @estructuras_ficticias = GovernanceStructure.where("enterprise_id = ?", 0)

    		@risks = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
    		@categories = RiskCategory.where("id_padre IS NULL")
			@genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, @empresa.id).order(dimension: :asc)

			# Según el tipo de mapa, lo redirige:
			@map = DecisionMap.find(params[:idMap].to_i)
			@details = @map.map_details
			@resps = [DELEG_RESP_1,DELEG_RESP_2,DELEG_RESP_3,DELEG_RESP_4,DELEG_RESP_5]
		end
		
	end
	# ---------------


	def get_decision
		dec = GovernanceDecision.find(params[:id])
		respond_to do |format|
        	if !dec.nil? # OK
        		format.json {render json: dec}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
		
	end
	# ------------

	def get_decisions_by_dim
		myDec = GovernanceDecision.find(params[:me].to_i)
		decsGen = GovernanceDecision.where("decision_type = ? AND dimension = ?", GENERIC_TYPE, params[:dim])
		decsEsp = GovernanceDecision.where("decision_type = ? AND dimension = ? AND enterprise_id = ?", SPECIFIC_TYPE, params[:dim], view_context.getMyEnterprise.id)
		decs = decsEsp + decsGen
	    # Remueve la propia decisión que se está tratando:
	    decs.delete(myDec)

		respond_to do |format|
			format.json {render json: decs}
    	end	
		
	end
	# -------------


	def update_decision
		dec = GovernanceDecision.find(params[:id].to_i)
		newDesc = params[:newDesc]
		newDim = params[:newDim]
		newPadre = params[:newPadre]
		if newPadre == 'NA'
			# SIN PADRE
			dec.parent_id = nil
			dec.decision_type = GENERIC_TYPE
			# Asigna también la empresa
			#dec.enterprise_id = nil
		else
			# CON PADRE
			dec.parent_id = newPadre
			dec.decision_type = SPECIFIC_TYPE
			# Asigna también la empresa
			dec.enterprise_id = getMyEnterpriseAPP.id
		end

		# Actualiza:
		dec.description = newDesc
		dec.dimension = newDim

		respond_to do |format|
        	if dec.save # OK
        		format.json {render json: dec}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end			
	end
	# -------------



	def get_archetypes
		emp = getMyEnterpriseAPP
		arquetipos = DecisionArchetype.all
		respond_to do |format|
      		format.json {render json: arquetipos}
    	end	
	end
	# ----------

	def get_dimensions
		emp = getMyEnterpriseAPP
		dimensiones = [view_context.translateDimension(DIM_DEC_1),view_context.translateDimension(DIM_DEC_2), 
			view_context.translateDimension(DIM_DEC_3), view_context.translateDimension(DIM_DEC_4), 
			view_context.translateDimension(DIM_DEC_5)]
		respond_to do |format|
      		format.json {render json: dimensiones}
    	end	
	end
	# ----------

	def get_decs_stats_by_dim
		# Obtiene el numero de decisiones totales por dimensión en el sistema:
		emp = getMyEnterpriseAPP
		dimensiones = [DIM_DEC_1, DIM_DEC_2, DIM_DEC_3, DIM_DEC_4, DIM_DEC_5]
		stats = []

		dimensiones.each do |dim|
			stat = GovernanceDecision.where("enterprise_id = ? AND dimension = ?", emp.id, dim).size
			stats.push(stat.to_s)
		end

		respond_to do |format|
      		format.json {render json: stats}
    	end
	end
	# --------


	# Realiza una actualización via AJAX, de los detalles de un mapa de delegación de responsabilidades:
	def update_map_2
		ests = params[:idsEstructuras]
		decision = GovernanceDecision.find(params[:idDec].to_i)
		index = params[:idResp].to_i
		map = DecisionMap.find(params[:idMap].to_i)

		paraActualizar = ests.split("|")
		paraActualizar.sort {|a,b| a <=> b }
		newDetails = Array.new

		# Asigna el tipo de responsabilidad según el index:
		respType = ''
		case index
		when 1
			respType = DELEG_RESP_1
		when 2
			respType = DELEG_RESP_2
		when 3
			respType = DELEG_RESP_3
		when 4
			respType = DELEG_RESP_4
		when 5
			respType = DELEG_RESP_5
		end

		# Borra los detalles anteriores (para dicho index):
		aBorrar = map.map_details.select{|a| a.responsability_type == respType && a.governance_decision_id == decision.id}
		MapDetail.delete(aBorrar)
		# Asigna como detalles, los actuales:
        newDetails = map.map_details

		# Crea los nuevos detalles:
		paraActualizar.each do |est|
			detail = MapDetail.new
	    	detail.governance_structure_id = est.to_i
	    	detail.governance_decision_id = decision.id
	    	detail.decision_map_id = map.id
	    	detail.responsability_type = respType
	    	newDetails << detail
		end

		# Asigna los nuevos detalles al mapa:
		map.map_details = newDetails

		respond_to do |format|
        	if map.save # OK
        		format.json {render json: map}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end
		
	end
	# -------------

	# Realiza una actualización via AJAX, de los detalles de un mapa de arquetipos:
	def update_map
		ests = params[:idsEstructuras]
		decision = GovernanceDecision.find(params[:idDec].to_i)
		arch = params[:idArch].to_i
		map = DecisionMap.find(params[:idMap].to_i)

		paraActualizar = ests.split("|")
		paraActualizar.sort {|a,b| a <=> b }
		newDetails = Array.new

		# Borra los detalles anteriores (para dicho index):
		aBorrar = map.map_details.select{|a| a.decision_archetype_id == arch && a.governance_decision_id == decision.id}
		MapDetail.delete(aBorrar)
		# Asigna como detalles, los actuales:
        newDetails = map.map_details

		# Crea los nuevos detalles:
		paraActualizar.each do |est|
			detail = MapDetail.new
	    	detail.governance_structure_id = est.to_i
	    	detail.governance_decision_id = decision.id
	    	detail.decision_map_id = map.id
	    	detail.decision_archetype_id = arch
	    	newDetails << detail
		end

		# Asigna los nuevos detalles al mapa:
		map.map_details = newDetails

		respond_to do |format|
        	if map.save # OK
        		format.json {render json: map}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end
		
	end
	# ----------

	# Actualiza un registro de mecanismos adicionales:
	def update_mechanism
		textos = params[:newTexts]
		if textos.nil?
			textos = []
		end

		index = params[:idResp].to_i
		# Asigna el tipo de responsabilidad según el index:
		respType = ''
		case index
		when 1
			respType = DELEG_RESP_1
		when 2
			respType = DELEG_RESP_2
		when 3
			respType = DELEG_RESP_3
		when 4
			respType = DELEG_RESP_4
		when 5
			respType = DELEG_RESP_5
		end
        
        # Busca el detalle:
		detail = MapDetail.where("decision_map_id = ? AND governance_decision_id = ? AND responsability_type = ?", params[:idMap].to_i, params[:idDec].to_i, respType).first
		txtActual = ''

		if detail.nil? # Si no existia, lo crea:
			detail = MapDetail.new
	    	detail.governance_decision_id = params[:idDec].to_i
	    	detail.decision_map_id = params[:idMap].to_i
	    	detail.responsability_type = respType
		end

        # Genera el nuevo texto y lo asigna
		textos.each do |t|
			if txtActual == ''
				txtActual+= t
			else
				txtActual+= '|' + t
			end
		end

		# La respuesta serán los mecanismos actuales:
		mechsActuales = []

		if txtActual == ''
			# Debe borrarlo, porque no va a tener nada
			MapDetail.delete(detail)
			# Guarda el detalle:
			respond_to do |format|
				format.json {render :json => mechsActuales}
	    	end
		else
			detail.complementary_mechanisms = txtActual
			# Guarda el detalle:
			respond_to do |format|
	        	if detail.save # OK
	        		# Obtiene los mecanismos actuales y los envia:
	        		idMechs = txtActual.split("|")
	        		mechsActuales = ComplementaryMechanism.where(id: idMechs)
	        		format.json {render :json => mechsActuales}
	         	else # ERROR
	      			format.json {render :json => nil}
	      		end
	    	end
		end
	end
	# --------------

	# Obtiene la informacion de un hallazgo
	def get_finding_info
		idDec = params[:idDec].to_i
		idMap = params[:idMap].to_i
		hallazgo = Finding.where("decision_map_id = ? AND governance_decision_id = ?", idMap, idDec).first
		respond_to do |format|
			format.json {render json: hallazgo}
    	end
	end
	# -------------

	# Agrega o actualiza la informacion de un hallazgo
	def add_update_finding
		idDec = params[:idDec].to_i
		idMap = params[:idMap].to_i
		desc = params[:desc]
		proposedUpdt = params[:proposedUpdt]
		parsedRisks = params[:parsedRisks]
		# Busca el hallazgo a ver si debe crearlo o actualizarlo:
		finding = Finding.where("decision_map_id = ? AND governance_decision_id = ?", idMap, idDec).first

		if finding.nil?
			# Es nuevo, debe ser creado:
			finding = Finding.new	
      		finding.decision_map_id = idMap
	 		finding.governance_decision_id = idDec

	 		# Adicionalmente se debe verificar si ya existe un escenario de riesgo asociado a este mapa de decision, o si no para crearlo:
	 		# PENDIENTE: Relacion entre engines diferentes!
=begin 
	 		riskEsc = RiskEscenario.where("decision_map_id = ?", idMap).first
	 		if riskEsc.nil?
	 			# Debe crearlo, aunque si no hay riesgos asociados, no lo hace todavia
	 			if parsedRisks.length > 0
	 				mapa = DecisionMap.find(idMap)
	 				riskEsc = RiskEscenario.new
	 				riskEsc.name = 'Riesgos asociados al mapa de decisiones: ' << mapa.name
	 				riskEsc.enterprise_id = view_context.getMyEnterprise.id
	 				riskEsc.decision_map_id = idMap
	 				riskEsc.save
	 			end
	 		end
=end
		end

		# Obtiene de nuevo el escenario de riesgo asociado al mapa de decision en cuestion (ya deberia existir)
		# PENDIENTE: Relacion entre engines diferentes!
=begin
		riskEsc = RiskEscenario.where("decision_map_id = ?", idMap).first
		decisionMap = DecisionMap.find(riskEsc.decision_map_id)

		tokens = parsedRisks.split("|")

		# Por cada riesgo asociado, crea (si es necesario), un riesgo especifico generado automaticamente:
		tokens.each do |risk|
			riskPadre = Risk.find(risk.to_i)
			# Busca riesgos especificos asociados al escenario del mapa, si existen no debe hacer nada, si no crea 1
			risksTemp = Risk.where(risk_escenario_id: riskEsc.id, riesgo_padre_id: risk.to_i)
			if risksTemp.size == 0
				# No hay riesgs especificos asociados al escenario y al riesgo, debe crear al menos 1:
				newRisk = Risk.new
				newRisk.descripcion = 'Riesgo proveniente de la identificación de un hallazgo para el mapa de decisión ' + decisionMap.name
				newRisk.nivel = SPECIFIC_TYPE
				newRisk.riesgo_padre_id = risk.to_i
				newRisk.risk_category_id = riskPadre.risk_category_id
				newRisk.enterprise_id = riskEsc.enterprise_id
				newRisk.risk_escenario_id = riskEsc.id
				newRisk.save
			end
		end

=end

		# Realiza las actualizaciones:
		finding.description = desc
		finding.proposed_updates = proposedUpdt
		finding.parsed_risks = parsedRisks

		# Guarda los cambios:
		finding.save

		render nothing: true
	end
	# ----------

	# Agrega mecanismos complementarios via AJAX:
	def add_mechanism
		desc = params[:desc]
		idEmp = params[:idEmp].to_i
		m = ComplementaryMechanism.new
		m.description = desc
		m.enterprise_id = idEmp

		respond_to do |format|
			if m.save
				# Guardo OK:
				format.json {render json: m}
			else
				format.json {render json: nil}
			end
			
	    end 
	end
	# ------------

	# Obtiene los nombres de un listado de mapas de decision:
	def get_map_names
		idMapas = params[:idMaps].split("|")
		mapas = DecisionMap.where(id: idMapas)

		content = []

		mapas.each do |mapa|
			content.push(mapa.name << ' - ' << mapa.description)
		end

		respond_to do |format|
			# Envia el texto:
			format.json {render json: content}
	    end
	end
	# ----------

	# Obtiene la informacion relacionada a una decision, en caso de querer borrarla:
	def get_info_to_delete
		decision = GovernanceDecision.find(params[:idDec].to_i)
		hijasToDelete = view_context.recursiveDarHijos(decision, [])
		detailsToDelete = decision.map_details + view_context.darDetalles(hijasToDelete)
		findingsToDelete = decision.findings + view_context.darHallazgos(hijasToDelete)
		content = [decision.description, hijasToDelete.size.to_s, detailsToDelete.size.to_s, findingsToDelete.size.to_s]

		respond_to do |format|
			# Envia el texto:
			format.json {render json: content}
	    end
	end
	# -----------

	# Elimina una decision via ajax:
	def delete_decision
		# Por medio de la configuracion del modelo, todo lo relacionado con esa decision, y sus hijos se borrará también
		decision = GovernanceDecision.find(params[:idDecision].to_i)
		hijasToDelete = view_context.recursiveDarHijos(decision, []) # Agrega sus hijos
		hijasToDelete.push(decision.id) # Se agrega a si misma

		decision.destroy

		respond_to do |format|
			# Envia el texto:
			format.json {render json: hijasToDelete}
	    end
	end
	# ------------

	# Instancia las decisiones genericas para la empresa en cuestion:
	def instantiate_decisions
		emp = getMyEnterpriseAPP
		creadas = 0
		erradas = 0
		# Establece la ruta donde se encuentra el archivo de texto que contiene las decisiones genericas:
		fileRoute = Mapas::Engine.root.to_s+'/lib/scripts/decisions.txt'
		if I18n.default_locale.to_s.eql?("en")
			# En ingles es otro archivo
			fileRoute = Mapas::Engine.root.to_s+'/lib/scripts/decisionsEN.txt'	
		end
		
		File.open(fileRoute, "r").each_line do |line|
			# Cada linea viene: descripcion|dimension
			description = line.split("|")[0].strip
			dimension = line.split("|")[1].strip
			# Crea la decision, para la empresa tratada, y la asigna como generica:
			dec = GovernanceDecision.new
			dec.description = description
			dec.dimension = dimension
			dec.decision_type = GENERIC_TYPE
			dec.enterprise_id = emp.id
			if dec.save
				creadas+= 1
			else
				erradas+= 1
			end
		end

        if erradas > 0
        	flash[:alert] = 'ERROR: ' << erradas.to_s << '  generic decisions could not be created!'
        end

        if creadas > 0
        	flash[:notice] = creadas.to_s << ' generic decisions were created successfully for the enterprise ' << emp.name
        	if I18n.default_locale.to_s.eql?("en")
        		# Mensaje en ingles!
        		flash[:notice] = creadas.to_s << ' generic decisions were created successfully for the enterprise ' << emp.name
			end
        end

		redirect_to action: :decisions

	end
	# ------------------

	# Identificacion del arquetipo de gobierno
	def identify_archetype
		idMapas = params[:idMap].split("|")

		content = identify_archetype_method(idMapas) # EL metodo esta en InicioHelper
		

		respond_to do |format|
			# Envia el texto:
			format.json {render json: content}
	    end

	end # Cierra Identify_archetype

	def get_structures
		ests = getStructuresAPP
		respond_to do |format|
      		format.json {render json: ests}
    	end	
		
	end
	# ------------



  end
end
