DSS::Application.routes.draw do


  # Access to engine: Decision Maps:
  mount Mapas::Engine, at: "/eM"
  

  # Access to engine: Assessment Scenarios:
  mount Escenarios::Engine, at: "/eEE"
  

  # ===================== ENGINES =========================  
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   #root 'inicio#inicio'

  root :to => 'inicio#inicio'
  # Routes to creation and modification of governance structures
  get "governance/get_functions"
  post "governance/get_structure"
  post "governance/update_structure"
  post "governance/get_responsabilities"
  get "governance/structures"
  post "governance/add_structure"
  post "governance/add_responsability"
  get "autocomplete/responsabilities"

  # Routes IT Governance - END

  get "enterprises/new"
  get "enterprises/get_enterprise"
  get "enterprises/edit"
  post "enterprises/update"
  post "enterprises/resultado"
  post "config/resultado"
  get "config/riskmap" # Change to GET, provided the session use
  
  get "inicio/inicio"
  get '/admin', to: 'inicio#admin', :as => 'administrar'

  # Routes to generate HTML files to build the client apps:
  post "inicio/getFilterEmpresa" # Information to select what-to-generate
  post "inicio/g_home" # Initial screen
  post "inicio/g_decision_maps" # Decision Maps
  post "inicio/g_goal_escenarios" # Goal Assessment Scenarios 
  post "inicio/g_risk_escenarios" # Risk Assessment Scenarios
  post "inicio/g_priorization_escenarios" # Prioritization Scenarios
  post "inicio/session_config" # Session Configuration
end
