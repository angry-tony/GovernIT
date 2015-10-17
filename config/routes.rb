DSS::Application.routes.draw do


  # Acceso al engine de mapas de decision:
  authenticate :user do
     mount Mapas::Engine, at: "/eM"
  end

  # Acceso al engine de escenarios de evaluacion:
  authenticate :user do
     mount Escenarios::Engine, at: "/eEE"
  end


  # ===================== ENGINES =========================  

  # Rutas de DEVISE
  devise_for :users  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   #root 'inicio#inicio'

   # Siempre debe estar autenticado:
   authenticated :user do
    root :to => 'inicio#inicio', :as => :authenticated_root
    # Rutas para la creacion y modificacion de estructuras de gobierno
    get "governance/get_functions"
    post "governance/get_structure"
    post "governance/update_structure"
    post "governance/get_responsabilities"
    get "governance/structures"
    post "governance/add_structure"
    post "governance/add_responsability"
    get "autocomplete/responsabilities"
    # Rutas de administracion
    post "admin/file_users"

    # Rutas Gobierno de TI - FIN

    get "enterprises/new"
    get "enterprises/get_enterprise"
    get "enterprises/edit"
    post "enterprises/update"
    post "enterprises/resultado"
    post "config/resultado"
    get "config/riskmap" # Cambio a GET, por el uso de sesiones
    
    get "inicio/inicio"
    get '/admin', to: 'inicio#admin', :as => 'administrar'

    # Rutas para generar los archivos html de las aplicaicones cliente:
    post "inicio/getFilterEmpresa" # Informacion para seleccionar qué generar
    post "inicio/g_home" # Pantalla inicial
    post "inicio/g_decision_maps" # Mapas de decision
    post "inicio/g_goal_escenarios" # Escenarios de evaluacion de objetivos 
    post "inicio/g_risk_escenarios" # Escenarios de evaluacion de riesgos
    post "inicio/g_priorization_escenarios" # Escenarios de priorización
    get "inicio/modulos" # Accesos por modulo, según el usuario que está logueado
    post "inicio/session_config" # Configuracion de la sesion
   end
   
   root :to => redirect('/users/sign_in')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
