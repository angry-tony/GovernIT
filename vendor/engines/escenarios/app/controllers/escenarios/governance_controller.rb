#encoding: utf-8

# ==========================================================================
# GovernIT: A Software for Creating and Controlling IT Governance Models

# Copyright (C) 2015  Oscar González Rojas - Sebastián Lesmes Alvarado

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/

# Authors' contact information (e-mail):
# Oscar González Rojas: o-gonza1@uniandes.edu.co
# Sebastián Lesmes Alvarado: s.lesmes798@uniandes.edu.co

# ==========================================================================

require_dependency "escenarios/application_controller"

module Escenarios
  class GovernanceController < ApplicationController

  	# Escenarios de evaluación de riesgos:
	def risks
		@empresa = getMyEnterpriseAPP
		if !@empresa.nil?
			@escs = RiskEscenario.where("enterprise_id = ?", @empresa.id).order(id: :asc)
			infoMapas = getRiskedDecisionMaps
			@mapas = infoMapas[0]
			arrayIdsRiesgos = infoMapas[1] # Es un arreglo de arreglos de ids de riesgos
			@riesgos = [] # Es un arreglo de arreglos de riesgos
			arrayIdsRiesgos.each do |r|
				risks = Risk.where(id: r)
				@riesgos.push(risks)
			end

			@escs.each do |e|
				begin
		    	  authorize! :manage, e
			    rescue 
			      raise CanCan::AccessDenied.new("No tiene autorización para acceder a los escenarios de evaluación de riesgos de la empresa: " << @empresa.name )
			    end
			end
		else
			redirect_to root_url, :alert => 'ERROR: Empresa no encontrada. Debe seleccionar una empresa en el menú inicial'
		end
	end

	# Escenarios de evaluación de objetivos:
	def goals
		@empresa = getMyEnterpriseAPP
		if !@empresa.nil?
			@escs = GoalEscenario.where("enterprise_id = ?", @empresa.id).order(id: :asc)
			@escs.each do |e|
				begin
		    	  authorize! :manage, e
			    rescue 
			      raise CanCan::AccessDenied.new("No tiene autorización para acceder a los escenarios de evaluación de objetivos de la empresa: " << @empresa.name )
			    end
			end
		else
			redirect_to root_url, :alert => 'ERROR: Empresa no encontrada. Debe seleccionar una empresa en el menú inicial'
		end
	end
	# -------------
	

    # Creación de un riesgo especifico via AJAX
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
		#risk.risk_escenario_id = risk_escenario_id

		begin
		  authorize! :create, risk
		rescue 
		  raise CanCan::AccessDenied.new("No tiene autorización para crear riesgos específicos para la empresa: " << emp.name )
		end

        respond_to do |format|
        	if risk.save # OK
        		format.json {render json: risk}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end

    # Crea un escenario de evaluación de riesgos via AJAX:
	def add_risk_escenario
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		est = params[:est]

		authorize! :create, RiskEscenario
		esc = RiskEscenario.new
		esc.name = name
		esc.enterprise_id = @empresa.id
		esc.governance_structure_id = est.to_i

		begin
		  authorize! :create, esc
		rescue 
		  raise CanCan::AccessDenied.new("No tiene autorización para crear escenarios de evaluación de riesgos en la empresa: " << @empresa.name )
		end

		respond_to do |format|
        	if esc.save # OK
        		format.json {render json: esc}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end

	# Crea un escenario de evaluación de objetivos via AJAX:
	def add_goal_escenario
		@empresa = getMyEnterpriseAPP
		name = params[:name]
		est = params[:est]

		authorize! :create, RiskEscenario
		esc = GoalEscenario.new
		esc.name = name
		esc.enterprise_id = @empresa.id
		esc.governance_structure_id = est.to_i

		begin
		  authorize! :create, esc
		rescue 
		  raise CanCan::AccessDenied.new("No tiene autorización para crear escenarios de evaluación de objetivos en la empresa: " << @empresa.name )
		end

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

		begin
		  authorize! :create, esc
		rescue 
		  raise CanCan::AccessDenied.new("No tiene autorización para crear escenarios de priorización en la empresa: " << @empresa.name )
		end

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

			begin
			  authorize! :manage, @escenario
			rescue 
			  raise CanCan::AccessDenied.new("No tiene autorización para acceder al escenario de evaluación de riesgos: " << @escenario.name )
			end

			@cals = @escenario.califications
			@tipoEscenario = ''
			# Según el tipo de escenario (manual o generado), los riesgos se restringen:
			if @escenario.decision_map_id.nil?
				# Manual, muestra todo:
				@risks = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
				@tipoEscenario = RISK_ESC_MANUAL
			else
				@risks = getRisksFromDecisionMap(@escenario.decision_map_id)
				@tipoEscenario = RISK_ESC_GENERADO
			end
    		
    		@hijos = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id)

    		riskmap = @empresa.configuracion
		    # Si no encuentra la configuración, la envía vacía:
		    if riskmap.nil?
		        # Envía en los niveles, los valores por defecto
		        default = RISK_SCALE   
		        @niveles = default.split('|')
		    else
		        if riskmap.riskmap.nil? or riskmap.riskmap.empty?
		          # Envía en los niveles, los valores por defecto
		          default = RISK_SCALE   
		          @niveles = default.split('|')
		        else
		          @niveles = riskmap.riskmap.split('|')
		        end
		    end
		end
		
	end

    # Detalle de un escenario de evaluacion de objetivos
	def goal_escenario
		@empresa = getMyEnterpriseAPP

		if !@empresa.nil?
			@escenario = GoalEscenario.find(params[:idEsc].to_i)
			begin
			  authorize! :manage, @escenario
			rescue 
			  raise CanCan::AccessDenied.new("No tiene autorización para acceder al escenario de evaluación de objetivos: " << @escenario.name )
			end

			@cals = @escenario.goal_califications
			# Objetivos de Negocio:
			@bGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL)
			# Objetivos de TI:
			@itGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL)
			# Dimensiones:
			@it_dims = @itGoals.map { |goal| goal.dimension }.uniq
			@b_dims = @bGoals.map { |goal| goal.dimension }.uniq
			# Especificos:
			@especificos = Goal.where("goal_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, @empresa.id)
		end
		
	end
	



    # Actualiza una calificacion de un escenario de evaluacion de riesgos:
	def update_risk_cal
		# Obtiene la nueva descripcion del riesgo:
		nuevaDesc = params[:nuevaDesc]
		# Obtiene los parametros de la calificacion:
		valor = params[:valor]
		cantidad = params[:cantidad]
		tipo = params[:tipo]
		evidencia = params[:evidencia]
		riesgo = Risk.find(params[:riesgo].to_i)
	    # Actualiza la descripcion del riesgo:
	    riesgo.descripcion = nuevaDesc

		# Obtiene el escenario y sus calificaciones previamente guardadas:
		escenario = RiskEscenario.find(params[:escenario].to_i)



		# Busca en la tabla de calificaciones, si dicha calificacion ya existia la actualiza, sino la crea:
		cal = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", riesgo.id, escenario.id).first
		if cal.nil?
			# No existe, la crea (siempre y cuando no venga nulo su valor):
			cal = RiskCalification.new
			cal.risk_id = riesgo.id
			cal.valor = valor
			cal.cantidad = cantidad
			cal.risk_type = tipo
			cal.evidence = evidencia
			cal.risk_escenario_id = escenario.id
		else
			# Existia antes, la actualiza:
			cal.risk_id = riesgo.id
			cal.valor = valor
			cal.cantidad = cantidad
			cal.risk_type = tipo
			cal.evidence = evidencia
			cal.risk_escenario_id = escenario.id
		end

		respond_to do |format|
        	if cal.save && riesgo.save # OK

        		# Actualiza también el valor de su riesgo padre:

        		# El valor es el promedio de las calificaciones de sus hijos:
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
					# No existe, la crea:
					calGen = RiskCalification.new
					calGen.risk_id = riesgo.riesgo_padre_id
					calGen.valor = valor.to_i
					#La cantidad es la suma de las calificaciones de sus hijos:
					calGen.cantidad = cantidad.to_i
					calGen.evidence = 'N/A'
					calGen.risk_escenario_id = escenario.id
				else
					# Existia antes, la actualiza:
					calGen.risk_id = riesgo.riesgo_padre_id
					calGen.valor = valor.to_i
					#La cantidad es la suma de las calificaciones de sus hijos:
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

	# Actualiza una calificacion de un escenario de evaluacion de objetivos:
	def update_goal_cal
		# Obtiene los parametros de la calificacion:
		importance = params[:importance]
		performance = params[:performance]
		goal = Goal.find(params[:goal].to_i)
		# Obtiene el escenario y sus calificaciones previamente guardadas:
		escenario = GoalEscenario.find(params[:escenario].to_i)


		# Busca en la tabla de calificaciones, si dicha calificacion ya existia la actualiza, sino la crea:
		cal = GoalCalification.where("goal_id = ? AND goal_escenario_id = ?", goal.id, escenario.id).first
		if cal.nil?
			# No existe, la crea:
			cal = GoalCalification.new
			cal.goal_id = goal.id
			cal.importance = importance
			cal.performance = performance
			cal.goal_escenario_id = escenario.id
		else
			# Existia antes, la actualiza:
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

    # Obtiene la información de un objetivo (Petición AJAX - Tipo GET)
	def get_info_goal
		goal = Goal.find(params[:id].to_i)
		respond_to do |format|
			format.json {render json: goal}
    	end	
	end

	# Obtiene la informacion de una calificacion de un riesgo:
	def get_info_cal_risk
		cal = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", params[:idRisk].to_i, params[:idEsc].to_i).first
		respond_to do |format|
			format.json {render json: cal}
    	end
	end

	# Obtiene la informacion de una calificacion de un objetivo:
	def get_info_cal_goal
		resp = []
		goal = Goal.find(params[:idGoal].to_i)
		cal = GoalCalification.where("goal_id = ? AND goal_escenario_id = ?", params[:idGoal].to_i, params[:idEsc].to_i).first
		# Envia: La descripcion del objetivo, y la calificacion actual (si existe)
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



	# Crea un objetivo especifico via AJAX:
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
		  # Viene el riesgo hijo
		  riskId = Risk.find(params[:riesgo].to_i).riesgo_padre_id
		else
		  # Viene el riesgo padre:
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

	# Borra un riesgo especifico y sus calificaciones, y actualiza las calificaciones de su padre:
	def delete_risk
		riesgo = Risk.find(params[:idRisk].to_i)
		padre = Risk.find(riesgo.riesgo_padre_id)

		# Primero obtiene todas sus calificaciones:
		misCals = RiskCalification.where("risk_id = ?", riesgo.id)
		# Mapea los escenarios de donde pertenecen las calificaciones:
		misEsc = misCals.map {|cal| cal.risk_escenario_id}.uniq

		# Se implementa una transaccion, para evitar problemas:
		RiskCalification.transaction do
			# Inicia la transaccion

			# Obtiene los hijos(ya con el riesgo eliminado y no incluido):
			hijos = Risk.where("riesgo_padre_id = ?", padre.id).map {|h| h.id}
			# Elimina el hijo que se va a borrar, del arreglo de hijos, para no tenerlo en cuenta:
			hijos.delete(riesgo.id)

			# Recorre cada escenario, recalculando cada una de las calificaciones del padre:
			misEsc.each do |esc|
				# Obtiene la calificacion del padre para ese escenario:
				calGen = RiskCalification.where("risk_id = ? AND risk_escenario_id = ?", padre.id, esc).first

				calsHijos = RiskCalification.where(risk_id: hijos, risk_escenario_id: esc)
				# Si se queda sin calificaciones, borra la del padre, pues ya no tiene sentido:
				if calsHijos.size == 0
					# Borra la del padre:
					RiskCalification.delete(calGen)
				else
					# Recalcula todo normalmente:
					valor = 0
					cantidad = 0
					calsHijos.each do |h|
						valor+= h.valor
						cantidad += h.cantidad
					end
					valor = valor / calsHijos.size
					# Actualiza el valor del padre:
					calGen.valor = valor
					calGen.cantidad = cantidad
					# Guarda el registro:
					calGen.save!
				end
			end

			# Ahora si elimina el riesgo, y sus calificaciones (posterior a la actualizacion correcta):

			# Borra sus calificaciones:
			RiskCalification.delete(misCals)
			# Borra el riesgo:
			Risk.delete(riesgo)

		end
		

		respond_to do |format|
			# Envia el padre, para posteriores consultas:
			format.json {render json: padre}
	    end

	end


	# Consolidación de escenarios de evaluacion de riesgos, promediando los valores posibles:
	def consolidate_risks
		escString = params[:consolidated]
		escIds = escString.split("|")
		# Antes de consolidarlo, verifica si esa empresa ya tiene uno, pues sólo se permitirá 1 consolidado:
		consEsc = RiskEscenario.where("enterprise_id = ? AND consolidate_info IS NOT NULL", getMyEnterpriseAPP.id).first
		# Variable que modela si se debe regenerar un escenario de priorizacion:
		reGenerar = false


		if consEsc.nil?
			# Si no existia, no importa, prosigue con la creación
			# Construye el escenario:
			consEsc = RiskEscenario.new
			consEsc.name = 'Riesgos consolidados de TI'
			consEsc.enterprise_id = getMyEnterpriseAPP.id
		else
			# Si, si existia, debe editarlo, borra las calificaciones viejas, y crea unas nuevas:
			RiskCalification.delete(consEsc.califications)
			# Como ya existia, verifica si debe generar otros escenario de priorizacion adicional:
			priorizados = PriorizationEscenario.where("risk_escenario_id = ?", consEsc.id)
			if priorizados.size > 0
				reGenerar = true
			end
		end

		# Asigna los escenarios relacionados:
		consEsc.consolidate_info = escString

		# Obtiene las calificaciones de los escenarios pedidos para consolidacion:
		totalCals = RiskCalification.where(risk_escenario_id: escIds).order(risk_id: :asc)
		# Obtiene la totalidad de los riesgos del sistema, que están disponibles para consolidar:
		genericos = Risk.where("nivel = ?", 'GENERICO')
		especificos = Risk.where("nivel = ? AND enterprise_id = ?",  SPECIFIC_TYPE, getMyEnterpriseAPP.id)
		# Ordena los riesgos especificos:
		especificos.sort {|a,b| a.id <=> b.id}


		# Arreglo de calificaciones y demás variables:
		avgCals = []

		# Ahora mediante iteraciones, crea las calificaciones promedio de los riesgos especificos:
		especificos.each do |esp|
			valor = 0
			cantidad = 0
			# Crea la calificacion:
			calTemp = RiskCalification.new
			calTemp.risk_id = esp.id

			# Obtiene las calificaciones disponibles de ese riesgo:
			calsDisp = totalCals.select{|c| c.risk_id == esp.id}
			# Depura las calificaciones:
			totalCals = totalCals - calsDisp
			# Calcula para el riesgo actual, los valores de calificacion:
			if calsDisp.size == 0
				# No hay calificaciones, no la agrega
			else
				# Si hay calificaicones, calcula su promedio:
				calsDisp.each do |h|
					valor+= h.valor
					cantidad += h.cantidad
				end
				valor = valor / calsDisp.size
				# Actualiza el valor del padre:
				calTemp.valor = valor
				calTemp.cantidad = cantidad
				calTemp.risk_type = 'No definido'
				calTemp.evidence = 'No definida'
				# Agrega la calificacion al arreglo:
				avgCals.push(calTemp)
			end			
		end

		# Ahora genera las calificaicones promedio de los riesgos genericos:
		genericos.each do |g|
			valor = 0
			cantidad = 0
			# Crea la calificacion:
			calTemp = RiskCalification.new
			calTemp.risk_id = g.id

			# Obtiene las calificaciones disponibles de los hijos para este padre:
			calsDisp = avgCals.select{|c| c.risk.riesgo_padre_id == g.id}
			# Calcula para el riesgo actual, los valores de calificacion:
			if calsDisp.size == 0
				# No hay calificaciones, no la agrega
			else
				# Si hay calificaicones, calcula su promedio:
				calsDisp.each do |h|
					valor+= h.valor
					cantidad += h.cantidad
				end
				valor = valor / calsDisp.size
				# Actualiza el valor del padre:
				calTemp.valor = valor
				calTemp.cantidad = cantidad
				calTemp.risk_type = 'No definido'
				calTemp.evidence = 'No definida'
				# Agrega la calificacion al arreglo:
				avgCals.push(calTemp)
			end	
		end

		# Finalmente asocia las calificaicones promedio al escenario creado y termina:
		consEsc.califications = avgCals
		if consEsc.save
			# Si debe regenerar el escenario, lo realiza:
			if reGenerar
				# Verifica cobertura:
				completitud = view_context.getPorcentajeRiesgos(consEsc)
				if completitud == 100.0
					regenerados = 0
					errados = 0
					# Debe generar otro escenario:
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
						flash[:notice] = 'El escenario de evaluación de riesgos consolidado, fue generado exitosamente!, adicionalmente se re-generaron nuevos escenarios de priorización (' << regenerados.to_s << ' escenarios)'
					elsif errados > 0
						flash[:alert] = 'ERROR: De los nuevos escenario de priorización que debían generarse, no se pudieron guardar ' << errados.to_s << ' de ellos!'						
					end
				end
			else
				# OK:
				flash[:notice] = 'El escenario de evaluación de riesgos consolidado, fue generado exitosamente!'
			end

			# Redirige al menú de escenarios de riesgos:
			redirect_to action: :risks
			
		else
			# ERROR:
			flash[:error] = 'ERROR: Generando el escenario de evaluación de riesgos consolidado!'
			# Redirige al menú de escenarios de riesgos:
			redirect_to action: :risks
		end		
	end

	def get_consolidate_info
		consolidado = RiskEscenario.where("enterprise_id = ? AND consolidate_info IS NOT NULL", params[:idEmp]).first
		if consolidado.nil?
			# No hay un consolidado
			renderText = 'EMPTY'
		else
			renderText = consolidado.consolidate_info
		end

		respond_to do |format|
			# Envia el texto:
			format.json {render json: renderText}
	    end

	end



    # Metodo de consulta a partir de un riesgo y un escenario de riesgo
	def getDeleteableRisk
		puedeBorrar = true
		# Obtiene el riesgo asociado:
	    risk = Risk.find(params[:id])
	    riskEsc = RiskEscenario.find(params[:risk_escenario_id].to_i)
	    # Si el riesgo es un riesgo generado, y su padre no tiene mas hijos, no permite su borrado!
	    if false #!risk.risk_escenario_id.nil? PENDIENTE!!!
	    	# Es generado, verifica el numero de hijos de su padre
	    	hijosPadre = Risk.where(nivel: SPECIFIC_TYPE, riesgo_padre_id: risk.riesgo_padre_id, enterprise_id: riskEsc.enterprise_id)
	    	if hijosPadre.size == 1
	    		# Solo tiene como hijo a si mismo, no debe dejar borrarlo!
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
        # Obtiene el riesgo asociado:
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

	# SLA: Metodo que dado el id de un mapa de decision, importa sus riesgos asociados en un escenario de evaluacion de riesgos
	def import_escenario
		idMapa = params[:imported].to_i
		creado = importRiskEscenarioFromDecisionMap(idMapa)
		if creado
			flash[:notice] = 'La información fue importada correctamente. Escenario de evaluación de riesgos generado exitosamente.'
		else
			flash[:error] = 'ERROR: Importando la información necesaria para generar el escenario de evaluación de riesgos!'
		end

		# Redirige al menú de escenarios de riesgos:
		redirect_to action: :risks
	end
	# --------- import_escenario


  end
end
