#encoding: utf-8

require_dependency "escenarios/application_controller"

module Escenarios
  class GovernanceController < ApplicationController

  	# ES: Escenarios de evaluación de riesgos:
  	# EN: Risk Assessment Scenarios
	def risks
		@empresa = getMyEnterpriseAPP
		if !@empresa.nil?
			@escs = RiskEscenario.where("enterprise_id = ?", @empresa.id).order(id: :asc)
			infoMapas = getRiskedDecisionMaps
			@mapas = infoMapas[0]
			arrayIdsRiesgos = infoMapas[1] # ES: Es un arreglo de arreglos de ids de riesgos - EN: Its an array of arrays of risk ids
			@riesgos = [] # ES: Es un arreglo de arreglos de riesgos - EN: Its an array of array of risks
			arrayIdsRiesgos.each do |r|
				risks = Risk.where(id: r)
				@riesgos.push(risks)
			end			
		else
			redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
		end
	end

	# ES: Escenarios de evaluación de objetivos:
	# EN: Goal Assessment Scenarios:
	def goals
		@empresa = getMyEnterpriseAPP
		if !@empresa.nil?
			@escs = GoalEscenario.where("enterprise_id = ?", @empresa.id).order(id: :asc)
		else
			redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
		end
	end
	# -------------
	

    # ES: Creación de un riesgo especifico via AJAX
    # EN: Creation of an specific risk through AJAX
	def add_specific_risk
		emp = getMyEnterpriseAPP
		params[:risk_escenario_id].nil? ? risk_escenario_id = nil : risk_escenario_id = params[:risk_escenario_id].to_i
		padre = Risk.find(params[:idPadre].to_i)
		desc = params[:desc]
		risk = Risk.new
		risk.descripcion = desc
		risk.nivel = SPECIFIC_TYPE
		risk.riesgo_padre_id = padre.id
		risk.risk_category_id = padre.risk_category_id
		risk.enterprise_id = emp.id 

        respond_to do |format|
        	if risk.save # OK
        		format.json {render json: risk}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end

    # ES: Crea un escenario de evaluación de riesgos via AJAX:
    # EN: Creates a risk assessment scenario through AJAX:
	def add_risk_escenario
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		est = params[:est]

		esc = RiskEscenario.new
		esc.name = name
		esc.enterprise_id = @empresa.id
		esc.governance_structure_id = est.to_i

		respond_to do |format|
        	if esc.save # OK
        		format.json {render json: esc}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end

	# ES: Crea un escenario de evaluación de objetivos via AJAX:
	# EN: Creates a goal assessment scenario through AJAX:
	def add_goal_escenario
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		est = params[:est]

		esc = GoalEscenario.new
		esc.name = name
		esc.enterprise_id = @empresa.id
		esc.governance_structure_id = est.to_i

		respond_to do |format|
        	if esc.save # OK
        		format.json {render json: esc}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end


	def add_priorization_esc
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		wrisk = params[:wrisk]
		wgoal = params[:wgoals]

		esc = PriorizationEscenario.new
		esc.name = name
		esc.risksWeight = wrisk
		esc.goalsWeight = wgoal
		esc.enterprise_id = @empresa.id

		respond_to do |format|
        	if esc.save # OK
        		format.json {render json: esc}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end




	def risk_escenario
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
			@categories = RiskCategory.where("id_padre IS NULL")
			@escenario = RiskEscenario.find(params[:idEsc].to_i)

			@cals = @escenario.califications
			@tipoEscenario = ''
			# ES: Según el tipo de escenario (manual o generado), los riesgos se restringen:
			# EN: Acording to the scenario's type (manual or generated), the risks are restricted:
			if @escenario.decision_map_id.nil?
				# ES: Manual, muestra todo:
				# EN: Manual, shows all
				@risks = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
				@tipoEscenario = RISK_ESC_MANUAL
			else
				@risks = getRisksFromDecisionMap(@escenario.decision_map_id)
				@tipoEscenario = RISK_ESC_GENERADO
			end
    		
    		@hijos = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id)

    		riskmap = @empresa.configuracion
		    # ES: Si no encuentra la configuración, la envía vacía:
		    # EN: If the configuration is not found, send it empty:
		    if riskmap.nil?
		        # ES: Envía en los niveles, los valores por defecto
		        # EN: Send the default values, in the levels
		        default = RISK_SCALE   
		        @niveles = default.split('|')
		    else
		        if riskmap.riskmap.nil? or riskmap.riskmap.empty?
		          # ES: Envía en los niveles, los valores por defecto
		          # EN: Send the default values, in the levels
		          default = RISK_SCALE   
		          @niveles = default.split('|')
		        else
		          @niveles = riskmap.riskmap.split('|')
		        end
		    end
		end
		
	end

    # ES: Detalle de un escenario de evaluacion de objetivos
    # EN: Detail of a goal assessment scenario
	def goal_escenario
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
			@escenario = GoalEscenario.find(params[:idEsc].to_i)
			@cals = @escenario.goal_califications
			# ES: Objetivos de Negocio:
			# EN: Business Goals
			@bGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL)
			# ES: Objetivos de TI:
			# EN: IT Goals:
			@itGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL)
			# ES: Dimensiones:
			# EN: Dimensions
			@it_dims = @itGoals.map { |goal| goal.dimension }.uniq
			@b_dims = @bGoals.map { |goal| goal.dimension }.uniq
			# ES: Especificos:
			# EN: Specific:
			@especificos = Goal.where("goal_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id)
		end
		
	end
	



    # ES: Actualiza una calificacion de un escenario de evaluacion de riesgos:
    # EN: Updates a score from a risk assessment scenario:
	def update_risk_cal
		# ES: Obtiene la nueva descripcion del riesgo:
		# EN: Get the new risk description:
		nuevaDesc = params[:nuevaDesc]
		# ES: Obtiene los parametros de la calificacion:
		# EN: Get the score parameters
		valor = params[:valor]
		cantidad = params[:cantidad]
		tipo = params[:tipo]
		evidencia = params[:evidencia]
		riesgo = Risk.find(params[:riesgo].to_i)
	    # ES: Actualiza la descripcion del riesgo:
	    # EN: Updates the risk description:
	    riesgo.descripcion = nuevaDesc

		# ES: Obtiene el escenario y sus calificaciones previamente guardadas:
		# EN: Get the scenario and its previously saved scores:
		escenario = RiskEscenario.find(params[:escenario].to_i)



		# ES: Busca en la tabla de calificaciones, si dicha calificacion ya existia la actualiza, sino la crea:
		# EN: Search in the scores table, if that score already exists, update it, if not, create it:
		cal = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", riesgo.id, escenario.id).first
		if cal.nil?
			# ES: No existe, la crea (siempre y cuando no venga nulo su valor):
			# EN: Doesn't exist, create it (only if the value comes null):
			cal = RiskCalification.new
			cal.risk_id = riesgo.id
			cal.valor = valor
			cal.cantidad = cantidad
			cal.risk_type = tipo
			cal.evidence = evidencia
			cal.risk_escenario_id = escenario.id
		else
			# ES: Existia antes, la actualiza:
			# EN: Exist before, update it:
			cal.risk_id = riesgo.id
			cal.valor = valor
			cal.cantidad = cantidad
			cal.risk_type = tipo
			cal.evidence = evidencia
			cal.risk_escenario_id = escenario.id
		end

		respond_to do |format|
        	if cal.save && riesgo.save # OK

        		# ES: Actualiza también el valor de su riesgo padre:
        		# EN: Updates also the value of its father risk (above its hierarchy):

        		# ES: El valor es el promedio de las calificaciones de sus hijos:
        		# EN: The value is calculated as the average of their "sons" scores:
				hijos = Risk.where("riesgo_padre_id = ?", riesgo.riesgo_padre_id).map {|h| h.id}
				calsHijos = RiskCalification.where(risk_id: hijos, risk_escenario_id: escenario.id)
				valor = 0
				cantidad = 0
				calsHijos.each do |h|
					valor+= h.valor
					cantidad += h.cantidad
				end
				valor = valor / calsHijos.size

				calGen = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", riesgo.riesgo_padre_id, escenario.id).first
				if calGen.nil?
					# ES: No existe, la crea:
					# EN: Doesn't exist, create it:
					calGen = RiskCalification.new
					calGen.risk_id = riesgo.riesgo_padre_id
					calGen.valor = valor.to_i
					# ES: La cantidad es la suma de las calificaciones de sus hijos:
					# EN: The quantity is the sum of their "sons" scores
					calGen.cantidad = cantidad.to_i
					calGen.evidence = 'N/A'
					calGen.risk_escenario_id = escenario.id
				else
					# ES: Existia antes, la actualiza:
					# EN: Exists before, updates it:
					calGen.risk_id = riesgo.riesgo_padre_id
					calGen.valor = valor.to_i
					# ES: La cantidad es la suma de las calificaciones de sus hijos:
					# EN: The quantity is the sum of their "sons" scores
					calGen.cantidad = cantidad.to_i
					calGen.evidence = 'N/A'
					calGen.risk_escenario_id = escenario.id
				end

				if calGen.save
					format.json {render json: cal}
				else
					format.json {render json: "ERROR"}
				end

         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
		
	end

	# ES: Actualiza una calificacion de un escenario de evaluacion de objetivos:
	# EN: Updates a score from a goal assessment scenario:
	def update_goal_cal
		# ES: Obtiene los parametros de la calificacion:
		# EN: Get the score's parameters
		importance = params[:importance]
		performance = params[:performance]
		goal = Goal.find(params[:goal].to_i)
		# ES: Obtiene el escenario y sus calificaciones previamente guardadas:
		# EN: Get the scenario and its previously saved scores:
		escenario = GoalEscenario.find(params[:escenario].to_i)


		# ES: Busca en la tabla de calificaciones, si dicha calificacion ya existia la actualiza, sino la crea:
		# EN: Search in the scores table, if that score existed before, update it, if not, create it:
		cal = GoalCalification.where("goal_id = ? AND goal_escenario_id = ?", goal.id, escenario.id).first
		if cal.nil?
			# ES: No existe, la crea:
			# EN: Doesn't exist, create it:
			cal = GoalCalification.new
			cal.goal_id = goal.id
			cal.importance = importance
			cal.performance = performance
			cal.goal_escenario_id = escenario.id
		else
			# ES: Existia antes, la actualiza:
			# EN: Existed before, updates it:
			cal.goal_id = goal.id
			cal.importance = importance
			cal.performance = performance
			cal.goal_escenario_id = escenario.id
		end

		respond_to do |format|
        	if cal.save # OK
        		format.json {render json: cal}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
		
	end

    # ES: Obtiene la información de un objetivo (Petición AJAX - Tipo GET)
    # EN: Get the goal information (AJAX GET - REQUEST)
	def get_info_goal
		goal = Goal.find(params[:id].to_i)
		respond_to do |format|
			format.json {render json: goal}
    	end	
	end

	# ES: Obtiene la informacion de una calificacion de un riesgo:
	# EN: Get the information from a risk's score:
	def get_info_cal_risk
		cal = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", params[:idRisk].to_i, params[:idEsc].to_i).first
		respond_to do |format|
			format.json {render json: cal}
    	end
	end

	# ES: Obtiene la informacion de una calificacion de un objetivo:
	# EN: Get the information from a gaol's score:
	def get_info_cal_goal
		resp = []
		goal = Goal.find(params[:idGoal].to_i)
		cal = GoalCalification.where("goal_id = ? AND goal_escenario_id = ?", params[:idGoal].to_i, params[:idEsc].to_i).first
		# ES: Envia: La descripcion del objetivo, y la calificacion actual (si existe)
		# EN: To-send: Goal's description, and the current score (if exists)
		resp[0] = goal.description
		if cal.nil?
			resp[1] = "0"
			resp[2] = "0"
		else
			resp[1] = cal.performance.to_s
			resp[2] = cal.importance.to_s
		end

		respond_to do |format|
			format.json {render json: resp}
    	end
	end



	# ES: Crea un objetivo especifico via AJAX:
	# EN: Creates a specific goal through AJAX:
	def add_specific_goal
		emp = getMyEnterpriseAPP
		description = params[:description]
		padre = Goal.find(params[:id_padre].to_i)
		goal = Goal.new
		goal.description = description
		goal.goal_type = SPECIFIC_TYPE
		goal.scope = padre.scope
		goal.dimension = padre.dimension
		goal.parent_id = padre.id
		goal.enterprise_id = emp.id

		respond_to do |format|
        	if goal.save # OK
        		format.json {render json: goal}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	

	end



	def get_risk_cal
		if !params[:riesgo].nil?
		  # ES: Viene el riesgo hijo
		  # EN: It comes the son risk
		  riskId = Risk.find(params[:riesgo].to_i).riesgo_padre_id
		else
		  # ES: Viene el riesgo padre:
		  # EN: It comes the father risk
		  riskId = params[:padreId].to_i
		end
		
		escenarioId = params[:escenario].to_i
		cal = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", riskId, escenarioId).first

		if cal.nil?
			resp = riskId.to_s << '|' << 'N'
		else
			resp = riskId.to_s << '|' << cal.valor.to_s
		end
		
		respond_to do |format|
			format.json {render text: resp}
    	end
	end

	# ES: Borra un riesgo especifico y sus calificaciones, y actualiza las calificaciones de su padre:
	# EN: Deletes a specific risk and its scores, and updates its father's scores
	def delete_risk
		riesgo = Risk.find(params[:idRisk].to_i)
		padre = Risk.find(riesgo.riesgo_padre_id)

		# ES: Primero obtiene todas sus calificaciones:
		# EN: First of all get all its scores:
		misCals = RiskCalification.where("risk_id = ?", riesgo.id)
		# ES: Mapea los escenarios de donde pertenecen las calificaciones:
		# EN: Maps the scenarios where the scores belongs:
		misEsc = misCals.map {|cal| cal.risk_escenario_id}.uniq

		# ES: Se implementa una transaccion, para evitar problemas:
		# EN: A transaction is implemented, to avoid consistency problems:
		RiskCalification.transaction do
			# ES: Inicia la transaccion
			# EN: Initiates the transaction

			# ES: Obtiene los hijos(ya con el riesgo eliminado y no incluido):
			# EN: Get the sons (already with the risk eliminated and not included):
			hijos = Risk.where("riesgo_padre_id = ?", padre.id).map {|h| h.id}
			# ES: Elimina el hijo que se va a borrar, del arreglo de hijos, para no tenerlo en cuenta:
			# EN: Deletes the son to be eliminated, from the sons array, to discard it:
			hijos.delete(riesgo.id)

			# ES: Recorre cada escenario, recalculando cada una de las calificaciones del padre:
			# EN: Go over every scenario, re-calculating each one of its father's scores:
			misEsc.each do |esc|
				# ES: Obtiene la calificacion del padre para ese escenario:
				# EN: Get the father score in that scenario:
				calGen = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", padre.id, esc).first

				calsHijos = RiskCalification.where(risk_id: hijos, risk_escenario_id: esc)
				# ES: Si se queda sin calificaciones, borra la del padre, pues ya no tiene sentido:
				# EN: If there are no more scores, deletes the father score too:
				if calsHijos.size == 0
					# ES: Borra la del padre:
					# EN: Deletes the father score:
					RiskCalification.delete(calGen)
				else
					# ES: Recalcula todo normalmente:
					# EN: Recalculates everything normally:
					valor = 0
					cantidad = 0
					calsHijos.each do |h|
						valor+= h.valor
						cantidad += h.cantidad
					end
					valor = valor / calsHijos.size
					# ES: Actualiza el valor del padre:
					# EN: Updates the father's value:
					calGen.valor = valor
					calGen.cantidad = cantidad
					# ES: Guarda el registro:
					# EN: Save the record:
					calGen.save!
				end
			end

			# ES: Ahora si elimina el riesgo, y sus calificaciones (posterior a la actualizacion correcta):
			# EN: Now is the moment to eliminate the risk, and its scores (after the correct update):

			# ES: Borra sus calificaciones:
			# EN: Delete its scores:
			RiskCalification.delete(misCals)
			# ES: Borra el riesgo:
			# EN: Delete the risk:
			Risk.delete(riesgo)

		end
		

		respond_to do |format|
			# ES: Envia el padre, para posteriores consultas:
			# EN: Send the father, to later queries:
			format.json {render json: padre}
	    end

	end


	# ES: Consolidación de escenarios de evaluacion de riesgos, promediando los valores posibles:
	# EN: Consolidation of the risk assessment scenarios, averaging the possible values:
	def consolidate_risks
		escString = params[:consolidated]
		escIds = escString.split("|")
		# ES: Antes de consolidarlo, verifica si esa empresa ya tiene uno, pues sólo se permitirá 1 consolidado:
		# EN: Previous to consolidate, verify if that enterprise already has a consolidated scenario, because only 1 per enterprise is allowed:
		consEsc = RiskEscenario.where("enterprise_id = ? AND consolidate_info IS NOT NULL", getMyEnterpriseAPP.id).first
		# ES: Variable que modela si se debe regenerar un escenario de priorizacion:
		# EN: Variable to model if a prioritization scenario requires a re-generation: 
		reGenerar = false


		if consEsc.nil?
			# ES: Si no existia, no importa, prosigue con la creación
			# EN: If didn't exist, its ok, proceed creating:

			# ES: Construye el escenario:
			# EN: Build the scenario:
			consEsc = RiskEscenario.new
			consEsc.name = 'IT Consolidated Risks'
			consEsc.enterprise_id = getMyEnterpriseAPP.id
		else
			# ES: Si, si existia, debe editarlo, borra las calificaciones viejas, y crea unas nuevas:
			# EN: If the scenario existed, an edition is required, delete the old scores, and create new ones:
			RiskCalification.delete(consEsc.califications)
			# ES: Como ya existia, verifica si debe generar otros escenario de priorizacion adicional:
			# EN: Given that the scenario existed, verify if is required to re-generate additional prioritization scenarios:
			priorizados = PriorizationEscenario.where("risk_escenario_id = ?", consEsc.id)
			if priorizados.size > 0
				reGenerar = true
			end
		end

		# ES: Asigna los escenarios relacionados:
		# EN: Assign the related scenarios:
		consEsc.consolidate_info = escString

		# ES: Obtiene las calificaciones de los escenarios pedidos para consolidacion:
		# EN: Get the scores of the requested-to-consolidate scenarios: 
		totalCals = RiskCalification.where(risk_escenario_id: escIds).order(risk_id: :asc)
		# ES: Obtiene la totalidad de los riesgos del sistema, que están disponibles para consolidar:
		# EN: Get all the risks in the system, available to consolidate:
		genericos = Risk.where("nivel = ?", 'GENERICO')
		especificos = Risk.where("nivel = ? AND enterprise_id = ?",  SPECIFIC_TYPE, getMyEnterpriseAPP.id)
		# ES: Ordena los riesgos especificos:
		# EN: Sort the scpecific risks:
		especificos.sort {|a,b| a.id <=> b.id}


		# ES: Arreglo de calificaciones y demás variables:
		# EN: Scores array, and other variables:
		avgCals = []

		# ES: Ahora mediante iteraciones, crea las calificaciones promedio de los riesgos especificos:
		# EN: Now through iterations, create the average scores of the specific risks:
		especificos.each do |esp|
			valor = 0
			cantidad = 0
			# ES: Crea la calificacion:
			# EN: Creates the score:
			calTemp = RiskCalification.new
			calTemp.risk_id = esp.id

			# ES: Obtiene las calificaciones disponibles de ese riesgo:
			# EN: Get the available scores of that risk:
			calsDisp = totalCals.select{|c| c.risk_id == esp.id}
			# ES: Depura las calificaciones:
			# EN: Debbug the scores:
			totalCals = totalCals - calsDisp
			# ES: Calcula para el riesgo actual, los valores de calificacion:
			# EN: Calculate for the current risk, the score's values:
			if calsDisp.size == 0
				# ES: No hay calificaciones, no la agrega
				# EN: There are no scores, don't add them
			else
				# ES: Si hay calificacicones, calcula su promedio:
				# EN: There are scores, calculate its average:
				calsDisp.each do |h|
					valor+= h.valor
					cantidad += h.cantidad
				end
				valor = valor / calsDisp.size
				# ES: Actualiza el valor del padre:
				# EN: Updates the father's value:
				calTemp.valor = valor
				calTemp.cantidad = cantidad
				calTemp.risk_type = 'No definido'
				calTemp.evidence = 'No definida'
				# ES: Agrega la calificacion al arreglo:
				# EN: Add the score to the array:
				avgCals.push(calTemp)
			end			
		end

		# ES: Ahora genera las calificaicones promedio de los riesgos genericos:
		# EN: Now generate the average scores of the generic risks:
		genericos.each do |g|
			valor = 0
			cantidad = 0
			# ES: Crea la calificacion:
			# EN: Create the score:
			calTemp = RiskCalification.new
			calTemp.risk_id = g.id

			# ES: Obtiene las calificaciones disponibles de los hijos para este padre:
			# EN: Get the available scores of the sons of this father:
			calsDisp = avgCals.select{|c| c.risk.riesgo_padre_id == g.id}
			# ES: Calcula para el riesgo actual, los valores de calificacion:
			# EN: Calculate for the current risk, the score's values:
			if calsDisp.size == 0
				# ES: No hay calificaciones, no la agrega
				# EN: There are no scores, don't add them
			else
				# ES: Si hay calificaicones, calcula su promedio:
				# EN: There are scores, calculate its average:
				calsDisp.each do |h|
					valor+= h.valor
					cantidad += h.cantidad
				end
				valor = valor / calsDisp.size
				# ES: Actualiza el valor del padre:
				# EN: Updates the father's value:
				calTemp.valor = valor
				calTemp.cantidad = cantidad
				calTemp.risk_type = 'No definido'
				calTemp.evidence = 'No definida'
				# ES: Agrega la calificacion al arreglo:
				# EN: Add the score to the array:
				avgCals.push(calTemp)
			end	
		end

		# ES: Finalmente asocia las calificaicones promedio al escenario creado y termina:
		# EN: Finally associate the average scores to the just-created scenario, and finish the process
		consEsc.califications = avgCals
		if consEsc.save
			# ES: Si debe regenerar el escenario, lo realiza:
			# EN: If the scenario must be re-generated, do it:
			if reGenerar
				# ES: Verifica cobertura:
				# EN: Verify coverage:
				completitud = view_context.getPorcentajeRiesgos(consEsc)
				if completitud == 100.0
					regenerados = 0
					errados = 0
					# ES: Debe generar otro escenario:
					# EN: Another scenario must be generated:
					riskE = consEsc
					priorizados.each do |priorizado|
						goalE = priorizado.goal_escenario 
						nameE = '[RE-GENERADO] ' << priorizado.name
						wRisk = priorizado.risksWeight
						wGoal = priorizado.goalsWeight
						emp = getMyEnterpriseAPP
						creado = view_context.generarPriorizacion(riskE, goalE, nameE, wRisk, wGoal, emp)
						if creado
							regenerados+= 1
						else
							errados+= 1
						end
					end
					
					if regenerados > 0
						flash[:notice] = 'The consolidated risk assessment scenario was generated successfully!, additionally new prioritization scenarios were re-generated (' << regenerados.to_s << ' scenarios)'
					elsif errados > 0
						flash[:alert] = 'ERROR: From the new prioritization scenarios to be re-generated, ' << errados.to_s << ' could not be saved!'						
					end
				end
			else
				# OK:
				flash[:notice] = 'The consolidated risk assessment scenario was generated successfully!'
			end

			# ES: Redirige al menú de escenarios de riesgos:
			# EN: Redirect to the risk assessment menu:
			redirect_to action: :risks
			
		else
			# ERROR:
			flash[:error] = 'ERROR: Generating the consolidated risk assessment scenario!'
			# ES: Redirige al menú de escenarios de riesgos:
			# EN: Redirect to the risk assessment menu:
			redirect_to action: :risks
		end		
	end

	def get_consolidate_info
		consolidado = RiskEscenario.where("enterprise_id = ? AND consolidate_info IS NOT NULL", params[:idEmp]).first
		if consolidado.nil?
			# ES: No hay un consolidado
			# EN: There is no consolidated scenario
			renderText = 'EMPTY'
		else
			renderText = consolidado.consolidate_info
		end

		respond_to do |format|
			# ES: Envia el texto:
			# EN: Send the text
			format.json {render json: renderText}
	    end

	end



    # ES: Metodo de consulta a partir de un riesgo y un escenario de riesgo
    # EN: Method to query given a risk and a risk assessment scenario
	def getDeleteableRisk
		puedeBorrar = true
		# ES: Obtiene el riesgo asociado:
		# EN: Get the related risk:
	    risk = Risk.find(params[:id])
	    riskEsc = RiskEscenario.find(params[:risk_escenario_id].to_i)
	    # ES: Si el riesgo es un riesgo generado, y su padre no tiene mas hijos, no permite su borrado!
	    # EN: If the risk is a generated risk, and its father has no more sons, can't allow its deleting!
	    if false #!risk.risk_escenario_id.nil? ES: PENDIENTE!!! - EN: TO-DO
	    	# ES: Es generado, verifica el numero de hijos de su padre
	    	# EN: Is generated, verify the number of sons of its father
	    	hijosPadre = Risk.where(nivel: SPECIFIC_TYPE, riesgo_padre_id: risk.riesgo_padre_id, enterprise_id: riskEsc.enterprise_id)
	    	if hijosPadre.size == 1
	    		# ES: Solo tiene como hijo a si mismo, no debe dejar borrarlo!
	    		# EN: Only 1 son left, can't allow its deleting!
	    		puedeBorrar = false
	    	end
	    end

	    respuesta = [risk, puedeBorrar]


	    respond_to do |format|
	      format.json {render json: respuesta}
	  end
	end
	# ----------

	def get_info_risk
        # ES: Obtiene el riesgo asociado:
        # EN: Get the related risk:
        risk = Risk.find(params[:id])
        resp = [risk.descripcion]

        respond_to do |format|
          format.json {render json: resp}
      end
    end
    # ---------------

    def get_structures
    	ests = getStructuresAPP
		respond_to do |format|
      		format.json {render json: ests}
    	end	
	end
	# ---------------

	# ES: Metodo que dado el id de un mapa de decision, importa sus riesgos asociados en un escenario de evaluacion de riesgos
	# EN: Method that given a decision map's id, import its related risks in a risk assessment scenario:
	def import_escenario
		idMapa = params[:imported].to_i
		creado = importRiskEscenarioFromDecisionMap(idMapa)
		if creado
			flash[:notice] = 'The information was imported correctly. Risk assessment scenario generated successfully.'
		else
			flash[:error] = 'ERROR: Importing the information needed to generate the risk assessment scenario!'
		end

		# ES: Redirige al menú de escenarios de riesgos:
		# EN: Redirect to the risk assessment scenarios menu:
		redirect_to action: :risks
	end
	# --------- import_escenario


  end
end
