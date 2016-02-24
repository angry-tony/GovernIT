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

	    # ES: Realiza la priorizacion y guarda el resultado:
	    # EN: Execute the prioritization and save the result:
	    hoy = (Time.now.year).to_s << '-' << Time.now.month.to_s << '-' << Time.now.mday.to_s
	    esc.fecha_ejecucion = hoy

	    # ES: PRIORIZA:
	    # EN: PRIORITIZATES:
	    stats = get_priorization_stats(esc)

	    esc.stats = stats


	  	# ES: Renderiza la respuesta según el resultado de la creación:
	  	# EN: Renders the answer according to the creation result:
	  	if esc.save
	  		return true
	  	else
	  		return false
	  	end
	end
	# -------------

  end
end
