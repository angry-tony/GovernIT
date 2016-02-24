#encoding: utf-8

require_dependency "escenarios/application_controller"

module Escenarios
  class PriorizationController < ApplicationController

  	def escenarios
	  @empresa = getMyEnterpriseAPP
	  if !@empresa.nil?
		  @escenarios = PriorizationEscenario.where("enterprise_id = ?", @empresa.id).order(risk_escenario_id: :asc)
      else
      	redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
	  end

  	end
  	# ------------------

	# ES: Petición GET, para obtener los escenarios de evaluación de riesgos:
	# EN: GET request, to get the risk assessment scenarios:
	def get_risk_escenarios
		emp = getMyEnterpriseAPP
		escs = RiskEscenario.where("enterprise_id = ?", emp.id)
		# ES: Renderiza la respuesta
		# EN: Renders the answer
		respond_to do |format|
			format.json {render json: escs}
		end
	end
	# ------------------

	# ES: Peticion GET, para obtener los porcentajes de completitud de cada escenario:
	# EN: GET request, to get the completeness percentages of each scenario:
	def get_porcentaje_escenarios
		emp = getMyEnterpriseAPP
		stats = []
		riskEscenarios = RiskEscenario.where(enterprise_id: emp.id) 
		goalEscenarios = GoalEscenario.where(enterprise_id: emp.id) 

		# ES: Porcentajes de los escenarios de riesgo:
		# EN: Risk scenarios percentages:
		riskEscenarios.each do |risk|
		    resp = view_context.getPorcentajeRiesgos(risk)
		  	# ES: Inserta el registro: TIPO_ESCENARIO|ID_ESCENARIO|PORCENTAJE
		  	# EN: Insert the record: SCENARIO_TYPE|SCENARIO_ID|PERCENTAGE
		  	value = 'RISK|' << risk.id.to_s << '|' << resp.to_s
		  	stats.push(value)
		end

		# ES: Porcentajes de los escenarios de objetivos:
		# EN: Goal scenarios percentages:
		goalEscenarios.each do |goal|
		 	resp = view_context.getPorcentajeObjetivos(goal)
		   	# ES: Inserta el registro: TIPO_ESCENARIO|ID_ESCENARIO|PORCENTAJE
		   	# EN: Insert the record: SCENARIO_TYPE|SCENARIO_ID|PERCENTAGE
		  	value = 'GOAL|' << goal.id.to_s << '|' << resp.to_s
		  	stats.push(value)
		end

		# ES: Renderiza la respuesta
		# EN: Renders the answer
		respond_to do |format|
		  format.json {render json: stats}
		end
	end
	# ----------------

	# ES: Peticion GET, para obtener los procesos:
	# EN: GET request, to get the processes
	def get_it_processes
		procs = ItProcess.all.order(id: :asc)
		# ES: Renderiza la respuesta
		# EN: Renders the answer
		respond_to do |format|
		  format.json {render json: procs}
		end
	end
	# --------------

	# ES: Petición GET, para obtener los escenarios de evaluación de objetivos:
	# EN: GET request, to get the goal assessment scenarios:
	def get_goal_escenarios
		emp = getMyEnterpriseAPP
		escs = GoalEscenario.where("enterprise_id = ?", emp.id)
		# ES: Renderiza la respuesta
		# EN: Renders the answer
		respond_to do |format|
			format.json {render json: escs}
		end
	end
	# ------------

	# ES: Petición POST, para agregar un nuevo escenario de priorización:
	# EN: POST request, to add a new prioritization scenario:
	def add_escenario
		emp = getMyEnterpriseAPP
		riskE = RiskEscenario.find(params[:riskE].to_i)
		goalE = GoalEscenario.find(params[:goalE].to_i)
		nameE = params[:nameE]
		wRisk = params[:wRisk]
		wGoal = params[:wGoal]

		esc = PriorizationEscenario.new
		esc.risk_escenario = riskE
		esc.goal_escenario = goalE
		esc.name = nameE
		esc.risksWeight = wRisk
		esc.goalsWeight = wGoal
		esc.enterprise = emp

		# ES: Realiza la priorizacion y guarda el resultado:
		# EN: Execute the prioritization and saves the result:
		hoy = (Time.now.year).to_s << '-' << Time.now.month.to_s << '-' << Time.now.mday.to_s
		esc.fecha_ejecucion = hoy

		# ES: PRIORIZA: - EN: PRIORITIZE
		stats = view_context.get_priorization_stats(esc)

		esc.stats = stats
		# ES: Renderiza la respuesta según el resultado de la creación:
		# EN: Renders the answer according to the creation result:
		respond_to do |format|
			if esc.save
				format.json {render json: esc}
			else
				format.json {render json: nil}
			end
		end
	end
	# ---------------

	def get_priorization_stats_html
		esc = PriorizationEscenario.find(params[:idEsc].to_i)
		toFormat = esc.stats.split("_$$_")
		stats = []
		# ES: Primera posicion, el nombre del escenario:
		# EN: First position, the scenario's name:
		stats[0] = esc.name << '    [ ' << esc.fecha_ejecucion.to_s << ' ]'
		# ES: Segunda posicion, el peso de los riesgos:
		# EN: Second position, the risks' weight:
		stats[1] = esc.risksWeight.to_s
		# ES: Tercera posicion, el peso de los objetivos:
		# EN: Third position, the goals' weight:
		stats[2] = esc.goalsWeight.to_s

		# ES: Formatea todos los stats, obteniendo la informacion adicional requerida de los procesos:
		# EN: Format all the stats, getting required additional information from the processes:
		procesos = ItProcess.all


		# ES: Cada linea debe ir:
		# # ID_Proceso_Fuente|Descripcion|importancia_riesgos|importancia_objetivos|importancia_total
		# EN: Every line must go:
		# # Process_ID(source)|Description|Risk_Importance|Goal_Importance|Total_Importance
		toFormat.each do |line|
		  split = line.split("|")
		  idProceso = split[0].to_i
		  proceso = procesos.select{|p| p.id == idProceso}.first
		  newLine = proceso.id_fuente << '|' << proceso.description << '|' << split[1] << '|' << split[2] << '|' << split[3]
		  stats.push(newLine)
		end

		# ES: Renderiza la respuesta para mostrar la tabla:
		# EN: Renders the answer to show the table:
		respond_to do |format|
		  format.json {render json: stats}
		end
	end
	# -----------------


  end
end
