Escenarios::Engine.routes.draw do

	# Rutas Escenarios de Priorización:
	get "priorization/escenarios" # Cambio a GET, por sesiones
	post "priorization/get_priorization_stats_html"
	post "priorization/add_escenario"
	get "priorization/get_risk_escenarios"
	get "priorization/get_goal_escenarios"
	get "priorization/get_it_processes"
	get "priorization/get_porcentaje_escenarios"
	
	get "governance/get_info_cal_risk"
	get "governance/get_info_cal_goal"
	post "governance/update_risk_cal"
	post "governance/consolidate_risks"
	post "governance/update_goal_cal"
	post "governance/add_specific_goal"
	get "governance/get_info_goal"
	post "governance/delete_risk"
	get "governance/get_consolidate_info"
	post "governance/getDeleteableRisk"
	post "governance/add_specific_risk"  
	post "governance/add_risk_escenario"  
	post "governance/add_goal_escenario"  
	get "governance/get_risk_cal"
	get "governance/risks" # Cambio a GET, por sesiones
	get "governance/goals" # Cambio a GET, por sesiones
	post "governance/risk_escenario"
	post "governance/goal_escenario"
	post "governance/get_info_risk"
 	get "governance/get_structures"
 	post "governance/import_escenario"
end
