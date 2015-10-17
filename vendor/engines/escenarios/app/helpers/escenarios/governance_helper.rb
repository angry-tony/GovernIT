module Escenarios
  module GovernanceHelper

  	include PriorizationHelper

	def generarPriorizacion(riskE, goalE, nameE, wRisk, wGoal, emp)
	  	esc = PriorizationEscenario.new
	  	esc.risk_escenario = riskE
	  	esc.goal_escenario = goalE
	  	esc.name = nameE
	  	esc.risksWeight = wRisk
	  	esc.goalsWeight = wGoal
	  	esc.enterprise = emp

	    # Realiza la priorizacion y guarda el resultado:
	    hoy = (Time.now.year).to_s << '-' << Time.now.month.to_s << '-' << Time.now.mday.to_s
	    esc.fecha_ejecucion = hoy

	    # PRIORIZA:
	    stats = get_priorization_stats(esc)

	    esc.stats = stats


	  	# Renderiza la respuesta según el resultado de la creación:
	  	if esc.save
	  		return true
	  	else
	  		return false
	  	end
	end
	# -------------

  end
end
