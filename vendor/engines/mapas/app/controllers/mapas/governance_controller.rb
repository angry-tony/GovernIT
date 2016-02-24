#encoding: utf-8

require_dependency "mapas/application_controller"

module Mapas
  class GovernanceController < ApplicationController

  	include SharedHelper

  	# EN: Decisiones
  	# ES: Decisions:
  	def decisions
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
			@dims = [DIM_DEC_1, DIM_DEC_2, DIM_DEC_3, DIM_DEC_4, DIM_DEC_5, DIM_DEC_6]
			# ES: Envia las genericas ordenadas por dimension, para realizar el agrupamiento:
			# EN: # Send the generic decisions, sorted by dimension, to perform a grouping:
			@genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, @empresa.id).order(dimension: :asc)
			# ES: Envia las especificas ordenadas por su padre, para realizar el agrupamiento:
			# EN: # Send the generic decisions, sorted by its father, to perform a grouping
		    @genericas.size == 0 ? @tieneDecisiones = false : @tieneDecisiones = true
		    @especificas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id).order(parent_id: :asc)
		else
			redirect_to main_app.root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu'
		end
	end
	# ----------- decisions


	# ES: Agregar decisiones especificas via AJAX:
	# EN: Add specific decisions through AJAX:
	def add_specific
		@empresa = getMyEnterpriseAPP
		padre = GovernanceDecision.find(params[:id_padre].to_i)
		# ES: Parametros para construir la decision:
		# EN: Parameters to build a new decisions:
		desc = params[:description]
		dim = padre.dimension
		# ES: Crea la decision:
		# EN: Creates the decision:
		decSpe = GovernanceDecision.new
		decSpe.description = desc
		decSpe.dimension = padre.dimension
		decSpe.decision_type = SPECIFIC_TYPE
		decSpe.parent_id = padre.id
		decSpe.enterprise_id = @empresa.id

		respond_to do |format|
			if decSpe.save
				# OK
				format.json {render json: decSpe}
			else
				# ES: No se pudo guardar
				# EN: Couldn't save
				format.json {render json: 'ERROR'}
			end
			
        end
	end
	# ------------

	# ES: Agregar decisiones genericas via AJAX:
	# EN: Add generic decisions through AJAX:
	def add_generic
		emp = getMyEnterpriseAPP
		dim = params[:dimension]
		# ES: La dimension puede venir en español o en ingles, verifica y ajusta (En la BD SIEMPRE EN ESPAÑOL!)
		# EN: The dimension could be in spanish or english, verify and adjust it (In the DB ALWAYS IN SPANISH!)
		if !I18n.default_locale.to_s.eql?("es")
			# ES: Viene en ingles, debe pasarla a español:
			# EN: English, must translate it:
			dim = view_context.translateDimensionToES(dim)
		end
		
		desc = params[:description]
		# ES: Crea una decision generica:
		# EN: Creates a generic decision:
		decGen = GovernanceDecision.new
		decGen.description = desc
		decGen.dimension = dim
		decGen.decision_type = GENERIC_TYPE
		decGen.enterprise_id = emp.id

		respond_to do |format|
			if decGen.save
				# OK
				format.json {render json: decGen}
			else
				# ES: No se pudo guardar
				# EN: Couldn't save
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

			# ES: Según el tipo de mapa, lo redirige:
			# EN: According to the map's type, redirect it:
			@map = DecisionMap.find(params[:idMap].to_i)
			@details = @map.map_details

			if @map.map_type.nil?
				# ES: Es nulo, aprovecha para actualizar su valor a mapa de arquetipos
				# EN: Null, update the value to archetype map
				@map.map_type = MAP_TYPE_1
				@map.save
				# ES: Redirige a su propio render, cargando los arquetipos apropiados
				# EN: Redirect to its own render, loading the appropiate archetypes
				@archs = DecisionArchetype.all

		    else
		    	# ES: Mapa de arquetipos:
		    	# EN: Archetype's map:

		    	# ES: Redirige a su propio render, cargando los arquetipos apropiados
		    	# EN: Redirect to its own render, loading the appropiate archetypes
				@archs = DecisionArchetype.all
			end

		end
		
	end
	# -----------

	def decision_map_2
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
		    @estructuras = GovernanceStructure.where("enterprise_id = ?", @empresa.id).order(id: :asc)
		    
		    # ES: Temporal: Se crearon 2 estructuras ficticias para modelar los valores "No aplica" y "No existe"
		    # EN: Temporary: 2 fake structures were created to modelate the values "Not Available" and "Not Exists"
		    @estructuras_ficticias = GovernanceStructure.where("enterprise_id = ?", 0)

    		@risks = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
    		@categories = RiskCategory.where("id_padre IS NULL")
			@genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, @empresa.id).order(dimension: :asc)

			# ES: Según el tipo de mapa, lo redirige:
			# EN: According the map's type, redirect it:
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
	    # ES: Remueve la propia decisión que se está tratando:
	    # EN: Removes the decision sent as a parameter:
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
			# ES: SIN PADRE
			# EN: NO-FATHER
			dec.parent_id = nil
			dec.decision_type = GENERIC_TYPE
		else
			# ES: CON PADRE
			# EN: WITH FATHER
			dec.parent_id = newPadre
			dec.decision_type = SPECIFIC_TYPE
			# ES: Asigna también la empresa
			# EN: Assign also the enterprise
			dec.enterprise_id = getMyEnterpriseAPP.id
		end

		# ES: Actualiza:
		# EN: Updates:
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
		# ES: Obtiene el numero de decisiones totales por dimensión en el sistema:
		# EN: Get the total number of decisions by dimensions in the system:
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


	# ES: Realiza una actualización via AJAX, de los detalles de un mapa de delegación de responsabilidades:
	# EN: Perform an update through AJAX, of the details from a responsibilities delegation map:
	def update_map_2
		ests = params[:idsEstructuras]
		decision = GovernanceDecision.find(params[:idDec].to_i)
		index = params[:idResp].to_i
		map = DecisionMap.find(params[:idMap].to_i)

		paraActualizar = ests.split("|")
		paraActualizar.sort {|a,b| a <=> b }
		newDetails = Array.new

		# ES: Asigna el tipo de responsabilidad según el index:
		# EN: Assign the responsibility type according to the index:
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

		# ES: Borra los detalles anteriores (para dicho index):
		# EN: Delete previous details (for that index):
		aBorrar = map.map_details.select{|a| a.responsability_type == respType && a.governance_decision_id == decision.id}
		MapDetail.delete(aBorrar)
		# ES: Asigna como detalles, los actuales:
		# EN: Assign as details, the current details
        newDetails = map.map_details

		# ES: Crea los nuevos detalles:
		# EN: Create the new details:
		paraActualizar.each do |est|
			detail = MapDetail.new
	    	detail.governance_structure_id = est.to_i
	    	detail.governance_decision_id = decision.id
	    	detail.decision_map_id = map.id
	    	detail.responsability_type = respType
	    	newDetails << detail
		end

		# ES: Asigna los nuevos detalles al mapa:
		# EN: Assign the new details to the map:
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

	# ES: Realiza una actualización via AJAX, de los detalles de un mapa de arquetipos:
	# EN: Performs an update through AJAX, of the details from an archetypes map:
	def update_map
		ests = params[:idsEstructuras]
		decision = GovernanceDecision.find(params[:idDec].to_i)
		arch = params[:idArch].to_i
		map = DecisionMap.find(params[:idMap].to_i)

		paraActualizar = ests.split("|")
		paraActualizar.sort {|a,b| a <=> b }
		newDetails = Array.new

		# ES: Borra los detalles anteriores (para dicho index):
		# EN: Delete previous details (for that index):
		aBorrar = map.map_details.select{|a| a.decision_archetype_id == arch && a.governance_decision_id == decision.id}
		MapDetail.delete(aBorrar)
		# ES: Asigna como detalles, los actuales:
		# EN: Assign as details, the current details:
        newDetails = map.map_details

		# ES: Crea los nuevos detalles:
		# EN: Create the new details:
		paraActualizar.each do |est|
			detail = MapDetail.new
	    	detail.governance_structure_id = est.to_i
	    	detail.governance_decision_id = decision.id
	    	detail.decision_map_id = map.id
	    	detail.decision_archetype_id = arch
	    	newDetails << detail
		end

		# ES: Asigna los nuevos detalles al mapa:
		# EN: Assign the new details to the map:
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

	# ES: Actualiza un registro de mecanismos adicionales:
	# EN: Updates a complementary mechanisms record:
	def update_mechanism
		textos = params[:newTexts]
		if textos.nil?
			textos = []
		end

		index = params[:idResp].to_i
		# ES: Asigna el tipo de responsabilidad según el index:
		# EN: Assign the responsibility type according the index:
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
        
        # ES: Busca el detalle:
        # EN: Search the detail:
		detail = MapDetail.where("decision_map_id = ? AND governance_decision_id = ? AND responsability_type = ?", params[:idMap].to_i, params[:idDec].to_i, respType).first
		txtActual = ''

		if detail.nil? # ES: Si no existia, lo crea: - EN: If not exist, create it:
			detail = MapDetail.new
	    	detail.governance_decision_id = params[:idDec].to_i
	    	detail.decision_map_id = params[:idMap].to_i
	    	detail.responsability_type = respType
		end

        # ES: Genera el nuevo texto y lo asigna
        # EN: Generates the new text and assign it
		textos.each do |t|
			if txtActual == ''
				txtActual+= t
			else
				txtActual+= '|' + t
			end
		end

		# ES: La respuesta serán los mecanismos actuales:
		# EN: The answer will be the current mechanisms:
		mechsActuales = []

		if txtActual == ''
			# ES: Debe borrarlo, porque no va a tener nada
			# EN: Need to delete it, because will be empty
			MapDetail.delete(detail)
			# ES: Guarda el detalle:
			# EN: Save the detail:
			respond_to do |format|
				format.json {render :json => mechsActuales}
	    	end
		else
			detail.complementary_mechanisms = txtActual
			# ES: Guarda el detalle:
			# EN: Save th detail:
			respond_to do |format|
	        	if detail.save # OK
	        		# ES: Obtiene los mecanismos actuales y los envia:
	        		# EN: Get the current mechanisms and send them:
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

	# ES: Obtiene la informacion de un hallazgo
	# EN: Get a finding's information
	def get_finding_info
		idDec = params[:idDec].to_i
		idMap = params[:idMap].to_i
		hallazgo = Finding.where("decision_map_id = ? AND governance_decision_id = ?", idMap, idDec).first
		respond_to do |format|
			format.json {render json: hallazgo}
    	end
	end
	# -------------

	# ES: Agrega o actualiza la informacion de un hallazgo
	# EN: Add or update the finding's information
	def add_update_finding
		idDec = params[:idDec].to_i
		idMap = params[:idMap].to_i
		desc = params[:desc]
		proposedUpdt = params[:proposedUpdt]
		parsedRisks = params[:parsedRisks]
		# ES: Busca el hallazgo a ver si debe crearlo o actualizarlo:
		# EN: Search the finding to see if needs to be created or updated:
		finding = Finding.where("decision_map_id = ? AND governance_decision_id = ?", idMap, idDec).first

		if finding.nil?
			# ES: Es nuevo, debe ser creado:
			# EN: Is new, needs to create it:
			finding = Finding.new	
      		finding.decision_map_id = idMap
	 		finding.governance_decision_id = idDec

	 		# ES:
	 		# Adicionalmente se debe verificar si ya existe un escenario de riesgo asociado a este mapa de decision, o si no para crearlo:
	 		# PENDIENTE: Relacion entre engines diferentes!

	 		# EN:
	 		# Additionally needs to verify if already exists a risk assessment scenario related to that decision map, if not, need to create it:
	 		# TO-DO: Relationship between different engines!
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

		# ES:
		# Obtiene de nuevo el escenario de riesgo asociado al mapa de decision en cuestion (ya deberia existir)
		# PENDIENTE: Relacion entre engines diferentes!

		# EN:
		# Get the risk assessment scenario related to the decision map (already existing)
		# TO-DO: Relationship between different engines!
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

		# ES: Realiza las actualizaciones:
		# EN: Performs the updates:
		finding.description = desc
		finding.proposed_updates = proposedUpdt
		finding.parsed_risks = parsedRisks

		# ES: Guarda los cambios:
		# EN: Save the changes:
		finding.save

		render nothing: true
	end
	# ----------

	# ES: Agrega mecanismos complementarios via AJAX:
	# EN: Add complementary mechanisms through AJAX:
	def add_mechanism
		desc = params[:desc]
		idEmp = params[:idEmp].to_i
		m = ComplementaryMechanism.new
		m.description = desc
		m.enterprise_id = idEmp

		respond_to do |format|
			if m.save
				# OK:
				format.json {render json: m}
			else
				format.json {render json: nil}
			end
			
	    end 
	end
	# ------------

	# ES: Obtiene los nombres de un listado de mapas de decision:
	# EN: Get the names from a list of decision maps:
	def get_map_names
		idMapas = params[:idMaps].split("|")
		mapas = DecisionMap.where(id: idMapas)

		content = []

		mapas.each do |mapa|
			content.push(mapa.name << ' - ' << mapa.description)
		end

		respond_to do |format|
			# ES: Envia el texto:
			# EN: Send the text
			format.json {render json: content}
	    end
	end
	# ----------

	# ES: Obtiene la informacion relacionada a una decision, en caso de querer borrarla:
	# EN: Get the information related to a decision, in case of a delete request:	
	def get_info_to_delete
		decision = GovernanceDecision.find(params[:idDec].to_i)
		hijasToDelete = view_context.recursiveDarHijos(decision, [])
		detailsToDelete = decision.map_details + view_context.darDetalles(hijasToDelete)
		findingsToDelete = decision.findings + view_context.darHallazgos(hijasToDelete)
		content = [decision.description, hijasToDelete.size.to_s, detailsToDelete.size.to_s, findingsToDelete.size.to_s]

		respond_to do |format|
			# ES: Envia el texto:
			# EN: Send the text:
			format.json {render json: content}
	    end
	end
	# -----------

	# ES: Elimina una decision via ajax:
	# EN: Delete a decision through AJAX:
	def delete_decision
		# ES: Por medio de la configuracion del modelo, todo lo relacionado con esa decision, y sus hijos se borrará también
		# EN: According to the model configuration, all information related to that decision and it sons will be deleted also
		decision = GovernanceDecision.find(params[:idDecision].to_i)
		hijasToDelete = view_context.recursiveDarHijos(decision, []) # ES: Agrega sus hijos - EN: Add it sons
		hijasToDelete.push(decision.id) # ES: Se agrega a si misma - EN: Add it itself

		decision.destroy

		respond_to do |format|
			# ES: Envia el texto:
			# EN: Send the text:
			format.json {render json: hijasToDelete}
	    end
	end
	# ------------

	# ES: Instancia las decisiones genericas para la empresa en cuestion:
	# EN: Instance the generic decision to relate them to the treated enterprise:
	def instantiate_decisions
		emp = getMyEnterpriseAPP
		creadas = 0
		erradas = 0
		# ES: Establece la ruta donde se encuentra el archivo de texto que contiene las decisiones genericas:
		# EN: Define the route where the text file with the generic decisions information is saved:
		fileRoute = Mapas::Engine.root.to_s+'/lib/scripts/decisions.txt'
		if I18n.default_locale.to_s.eql?("en")
			# ES: En ingles es otro archivo
			# EN: In english, the file is another one
			fileRoute = Mapas::Engine.root.to_s+'/lib/scripts/decisionsEN.txt'	
		end
		
		File.open(fileRoute, "r").each_line do |line|
			# ES: Cada linea viene: descripcion|dimension
			# EN: Each line comes: description|dimension
			description = line.split("|")[0].strip
			dimension = line.split("|")[1].strip
			# ES: Crea la decision, para la empresa tratada, y la asigna como generica:
			# EN: Creates the decision, for the treated enterprise, and assign them as generic:
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
        		# ES: Mensaje en ingles!
        		# EN: Message in english!
        		flash[:notice] = creadas.to_s << ' generic decisions were created successfully for the enterprise ' << emp.name
			end
        end

		redirect_to action: :decisions

	end
	# ------------------

	# ES: Identificacion del arquetipo de gobierno
	# EN: Identification of the governance archetype
	def identify_archetype
		idMapas = params[:idMap].split("|")

		content = identify_archetype_method(idMapas) # ES: EL metodo esta en InicioHelper - EN: The method definition is in "InicioHelper"
		

		respond_to do |format|
			# ES: Envia el texto:
			# EN: Send the text:
			format.json {render json: content}
	    end

	end # ------ identify_archetype

	def get_structures
		ests = getStructuresAPP
		respond_to do |format|
      		format.json {render json: ests}
    	end	
		
	end
	# ------------



  end
end
