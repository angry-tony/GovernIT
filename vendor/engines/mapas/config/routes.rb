Mapas::Engine.routes.draw do
  # Ruta autocomplete:
  get "autocomplete/mechanisms"

  # Rutas Gobierno de TI:
  get "governance/get_decs_stats_by_dim"
  post "governance/instantiate_decisions"
  post "governance/delete_decision"
  post "governance/get_info_to_delete"
  get "governance/get_map_names"
  post "governance/add_mechanism"

  get "governance/get_finding_info"
  post "governance/add_update_finding"
  get "governance/decisions" # Cambio a GET, por sesiones
  post "governance/get_decision"
  post "governance/get_decisions_by_dim"
  post "governance/update_decision"
  get "governance/get_archetypes"
  get "governance/get_dimensions"
  post "governance/add_generic"
  post "governance/add_specific"
  post "governance/add_map"
  get "governance/decision_maps" # Cambio a GET, por sesiones
  post "governance/decision_map"
  post "governance/decision_map_2"
  post "governance/update_map_2"
  post "governance/update_map"
  post "governance/update_mechanism"
  post "governance/identify_archetype"
  get "governance/get_structures"



end
