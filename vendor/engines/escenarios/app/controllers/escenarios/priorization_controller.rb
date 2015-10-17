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
  class PriorizationController < ApplicationController

  	def escenarios
	  @empresa = getMyEnterpriseAPP
	  if !@empresa.nil?
		  @escenarios = PriorizationEscenario.where("enterprise_id = ?", @empresa.id).order(risk_escenario_id: :asc)
	      @escenarios.each do |esc|
	        authorize! :manage, esc, :message => "No tiene autorización para acceder a los escenarios de priorización de la empresa: " << @empresa.name
	      end
      else
      	redirect_to root_url, :alert => 'ERROR: Empresa no encontrada. Debe seleccionar una empresa en el menú inicial'
	  end

  	end
  	# ------------------

	# Petición GET, para obtener los escenarios de evaluación de riesgos:
	def get_risk_escenarios
		emp = getMyEnterpriseAPP
		escs = RiskEscenario.where("enterprise_id = ?", emp.id)
		# Renderiza la respuesta
		respond_to do |format|
			format.json {render json: escs}
		end
	end
	# ------------------

	# Peticion GET, para obtener los porcentajes de completitud de cada escenario:
	def get_porcentaje_escenarios
		emp = getMyEnterpriseAPP
		stats = []
		riskEscenarios = RiskEscenario.where(enterprise_id: emp.id) 
		goalEscenarios = GoalEscenario.where(enterprise_id: emp.id) 

		# Porcentajes de los escenarios de riesgo:
		riskEscenarios.each do |risk|
	  		authorize! :read, risk, :message => "No tiene autorización para acceder al escenario de evaluación de riesgos: " << risk.name
		    resp = view_context.getPorcentajeRiesgos(risk)
		  	# Inserta el registro: TIPO_ESCENARIO|ID_ESCENARIO|PORCENTAJE
		  	value = 'RISK|' << risk.id.to_s << '|' << resp.to_s
		  	stats.push(value)
		end

		# Porcentajes de los escenarios de objetivos:
		goalEscenarios.each do |goal|
			authorize! :read, goal, :message => "No tiene autorización para acceder al escenario de evaluación de objetivos: " << goal.name
		 	resp = view_context.getPorcentajeObjetivos(goal)
		   	# Inserta el registro: TIPO_ESCENARIO|ID_ESCENARIO|PORCENTAJE
		  	value = 'GOAL|' << goal.id.to_s << '|' << resp.to_s
		  	stats.push(value)
		end

		# Renderiza la respuesta
		respond_to do |format|
		  format.json {render json: stats}
		end
	end
	# ----------------

	# Peticion GET, para obtener los procesos:
	def get_it_processes
		procs = ItProcess.all.order(id: :asc)
		# Renderiza la respuesta
		respond_to do |format|
		  format.json {render json: procs}
		end
	end
	# --------------

	# Petición GET, para obtener los escenarios de evaluación de objetivos:
	def get_goal_escenarios
		emp = getMyEnterpriseAPP
		escs = GoalEscenario.where("enterprise_id = ?", emp.id)
		# Renderiza la respuesta
		respond_to do |format|
			format.json {render json: escs}
		end
	end
	# ------------

	# Petición POST, para agregar un nuevo escenario de priorización:
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

		authorize! :create, esc, :message => "No tiene autorización para crear escenarios de priorización en la empresa: " << emp.name

		# Realiza la priorizacion y guarda el resultado:
		hoy = (Time.now.year).to_s << '-' << Time.now.month.to_s << '-' << Time.now.mday.to_s
		esc.fecha_ejecucion = hoy

		# PRIORIZA:
		stats = view_context.get_priorization_stats(esc)

		esc.stats = stats
		# Renderiza la respuesta según el resultado de la creación:
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
		# Primera posicion, el nombre del escenario:
		stats[0] = esc.name << '    [ ' << esc.fecha_ejecucion.to_s << ' ]'
		# Segunda posicion, el peso de los riesgos:
		stats[1] = esc.risksWeight.to_s
		# Tercera posicion, el peso de los objetivos:
		stats[2] = esc.goalsWeight.to_s

		# Formatea todos los stats, obteniendo la informacion adicional requerida de los procesos:
		procesos = ItProcess.all


		# Cada linea debe ir:
		# # ID_Proceso_Fuente|Descripcion|importancia_riesgos|importancia_objetivos|importancia_total
		toFormat.each do |line|
		  split = line.split("|")
		  idProceso = split[0].to_i
		  proceso = procesos.select{|p| p.id == idProceso}.first
		  newLine = proceso.id_fuente << '|' << proceso.description << '|' << split[1] << '|' << split[2] << '|' << split[3]
		  stats.push(newLine)
		end

		# Renderiza la respuesta para mostrar la tabla:
		respond_to do |format|
		  format.json {render json: stats}
		end
	end
	# -----------------


  end
end
