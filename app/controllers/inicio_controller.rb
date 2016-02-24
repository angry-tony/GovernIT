#encoding: utf-8

class InicioController < ApplicationController
  require 'fileutils'

  
  def inicio
    # ES: Las empresas se cargan según los roles del usuario: Si es evaluador, sólo carga su empresa, si es administrador, carga todas
    # EN: The enterprises are loaded according to the user's roles: If its an evaluator, only load its enterprise, if its an administratos, load all
    @empresas = Enterprise.all  
  end

  # ES: Menú de administración, para generar las aplicaciones cliente para cada empresa:
  # EN: Administration menu, to generate the client apps for each enterprise:
  def admin
  	@empresas = Enterprise.all
  end

  # ES: Todo el contenido seleccionable para generar el HTML:
  # EN: All the selectable content to generate the HTML:
  def getFilterEmpresa
    empresa = Enterprise.find(params[:idEmp].to_i)
    content = []
    # ES: El primer registro valida si la empresa tiene logo o no:
    # EN: The first record validates if the enterprise has logo or not:
    if empresa.logo.blank?
      content[0] = 'NO_LOGO'
    else
      content[0] = 'SI_LOGO'
    end


    # ES: Mapas de decision:
    # EN: Decision Maps:
    mapasFormateados = view_context.mapasListDecisionMaps(empresa.id)
    # ES: Agrega los mapas formateados:
    # EN: Add the formated maps
    content.concat(mapasFormateados)

    # ES: Escenarios de Evaluacion de Riesgos:
    # EN: Risk Assessment Scenarios:
    riesgosFormateados = view_context.escenariosListRiskEscenarios(empresa.id)
    # ES: Agrega los escenarios formateados:
    # EN: Add the formated scenarios:
    content.concat(riesgosFormateados)

    # ES: Escenarios de Evaluacion de Objetivos:
    # EN: Goal Assessment Scenarios:
    goalsFormateados = view_context.escenariosListGoalEscenarios(empresa.id)
    # ES: Agrega los escenarios formateados:
    # EN: Add the formated scenarios:
    content.concat(goalsFormateados)

    # ES: Escenarios de Priorizacion:
    # EN: Prioritization Scenarios:
    priorsFormateados = view_context.escenariosListPriorEscenarios(empresa.id)
    # ES: Agrega los escenarios formateados:
    # EN: Add the formated scenarios:
    content.concat(priorsFormateados)

    respond_to do |format|
      format.json {render json: content}
    end
  
  end 

  # ES: Genera la carpeta raiz de la empresa y las carpetas de imagenes y hojas de estilo, y alli crea el archivo inicial: index
  # EN: Generates the enterprise's root folder and the images and css folders, and there creates the initial file: index
  def g_home
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []


  	# ES: Directorio actual:
    # EN: Current directory
  	actualFolder = Rails.root.to_s
  	Dir.chdir(actualFolder)

  	# ES: Ruta archivo de estilos:
    # EN: CSS file path:
  	stylesRoute = actualFolder+'/app/assets/stylesheets/metro-bootstrap.css'
    stylesJqRoute = actualFolder+'/app/assets/stylesheets/my_jquery.css'
    imagesJqRoute = actualFolder+'/app/assets/stylesheets/images'
  	# ES: Ruta de la imagen de las jerarquias:
    # EN: Hierarchy image path
  	rightRoute = actualFolder+'/app/assets/images/right.png'
  	# ES: Rutas de las imagenes para la pantalla inicial:
    # EN: Paths of the images in the initial screen
  	mapRoute = actualFolder+'/app/assets/images/map_b.png'
  	riskRoute = actualFolder+'/app/assets/images/risk_b.png'
  	sortRoute = actualFolder+'/app/assets/images/sort_b.png'
    goalRoute = actualFolder+'/app/assets/images/goal_b.png'
    # ES: Rutas para las imagenes del dialogo de niveles de evaluacion de riesgos:
    # EN: Paths for the images in the dialog of risks assessment levels
    xAxisRoute = actualFolder+'/app/assets/images/x-axis.png'
    yAxisRoute = actualFolder+'/app/assets/images/y-axis.png'
    moneyRoute = actualFolder+'/app/assets/images/money.png'
    impTolRoute = actualFolder+'/app/assets/images/imp_tol.png'


  	# ES: Crea la carpeta que contendrá los contenidos HTML:
    # EN: Creates the directory that will contain the HTML contents:
  	rootFolder = 'HTML_CONTENT'
  	FileUtils.mkdir_p(rootFolder)
  	log.push("Creating initial page content...")
  	log.push("Directory created: " << rootFolder << '(Main directory)')

  	# ES: Actualiza el directorio actual: /HTML_CONTENT
    # EN: Updates the current directory: /HTML_CONTENT
  	actualFolder+= '/' + rootFolder
  	Dir.chdir(actualFolder)

  	# ES: Crea la carpeta, cuyo nombre será [ID_Empresa] Nombre
    # EN: Creates the folder, whose name will be [ENTERPRISE_ID] Name
  	folderName = '[' << empresa.id.to_s << '] ' << empresa.name
  	FileUtils.mkdir_p(folderName)
  	log.push("Directory created: " << folderName << '(Enterprise directory)')

  	# ES: Actualiza el directorio actual: /HTML_CONTENT/[ID_Empresa] Nombre
    # EN: Updates the current directory: /HTML_CONTENT/[ENTERPRISE_ID] Name
  	actualFolder+= '/' + folderName
  	Dir.chdir(actualFolder)
  	rootEmpresa = actualFolder

  	# ES: Crea la carpeta y el archivo de estilos:
    # EN: Creates the folder and css file:
  	FileUtils.mkdir_p('css')
  	log.push("Directory created: css (CSS files)" )
  	Dir.chdir(actualFolder+"/css")
  	FileUtils.cp stylesRoute, 'styles.css'

    # ES: Adentro copia el archivo de estilos de jquery, y su carpeta propia de imagenes:
    # EN: Inside copies the jquery css file, and its own images folder
    FileUtils.cp stylesJqRoute, 'my_jquery.css'
    FileUtils.mkdir_p('images')
    FileUtils.cp_r(Dir.glob(imagesJqRoute << '/*'), 'images')

  	# ES: Crea la carpeta de archivos .js:
    # EN: Creates the folder of .js files:
  	Dir.chdir(actualFolder)
  	FileUtils.mkdir_p('js')
  	log.push("Directory created: js (JavaScript files)")

  	# ES: Crea la carpeta de imagenes, y carga la imagen para las jerarquias en los mapas
    # EN: Create the images folder, and load the maps's hierarchy image
  	Dir.chdir(actualFolder)
  	FileUtils.mkdir_p('images')
  	log.push("Directory created: images (PNG files)")
  	Dir.chdir(actualFolder+"/images")
  	FileUtils.cp rightRoute, 'right.png'
  	FileUtils.cp mapRoute, 'map_b.png'
  	FileUtils.cp riskRoute, 'risk_b.png'
  	FileUtils.cp sortRoute, 'sort_b.png'
    FileUtils.cp goalRoute, 'goal_b.png'
    FileUtils.cp xAxisRoute, 'x-axis.png'
    FileUtils.cp yAxisRoute, 'y-axis.png'
    FileUtils.cp moneyRoute, 'money.png'
    FileUtils.cp impTolRoute, 'imp_tol.png'

    # ES: Define la ruta del logo si es necesario:
    # EN: Define the logo's path if its necesary:
    addLogo = params[:logo]
    if addLogo == 'SI'
      logoRoute = Rails.root.to_s << '/public/system/logos/' << empresa.id.to_s << '/' << empresa.logo_file_name
      FileUtils.cp logoRoute, empresa.id.to_s << '_' << empresa.logo_file_name
    end


    Dir.chdir(actualFolder)
  	# ES: Crea el archivo index:
    # EN: Creates the index file:
  	fileHtml = File.new("index.html", "w")
  	lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="./css/styles.css"/></head>'
  	fileHtml.puts lineHtml
  	lineHtml = '<body>'
  	fileHtml.puts lineHtml
  	lineHtml = '<div style="width:100%;height:400px;">'
    fileHtml.puts lineHtml
    lineHtml = '<div style="text-align:center;margin:40px 0px 40px 0px;">'
    fileHtml.puts lineHtml
    lineHtml = '<h2 style="font-size:60px;">IT Governance Model</h2></div><div style="margin-bottom:35px;">'
    fileHtml.puts lineHtml
    if addLogo == 'SI'
      lineHtml = '<center><img style="max-width:260px;max-height:230px;" src="./images/' << empresa.id.to_s << '_' << empresa.logo_file_name << '"></center>'
      fileHtml.puts lineHtml
    end

    lineHtml = '</div><div class="containerHome">'
  	fileHtml.puts lineHtml
  	lineHtml = '<center><img src="./images/map_b.png" style="margin:40px 0 20px 0;"></center>'
  	fileHtml.puts lineHtml
    lineHtml = '<h3 style="color:#333;font-size:22px;">Decision Maps</h3>'
    fileHtml.puts lineHtml

    # ES: Renderiza el link de cada mapa:
    # EN: Renders each map's link:
    mapIds = params[:mapIds].split("%")[0]
    mapIds.blank? ? mapIds = [] : mapIds = mapIds.split("|")
    mapas = Mapas::DecisionMap.where(id: mapIds)

    mapas.each do |m|
      lineHtml = '<a href="decisionMaps/map' << m.id.to_s << '.html">' << m.name << '</a><br>'
      fileHtml.puts lineHtml
    end


    lineHtml = '</div><div class="containerHome">'  	
    fileHtml.puts lineHtml
  	lineHtml = '<center><img src="./images/risk_b.png" style="margin:40px 0 20px 0;"></center>'
  	fileHtml.puts lineHtml
    lineHtml = '<h3 style="color:#333;font-size:22px;">Risk Assessment Scenarios</h3>'
  	fileHtml.puts lineHtml

    # ES: Renderiza el link de cada escenario:
    # EN: Renders each scenarios's link:
    riskIds = params[:riskIds].split("|")
    riskEsc = Escenarios::RiskEscenario.where(id: riskIds)

    riskEsc.each do |esc|
      lineHtml = '<a href="riskEscenarios/esc' << esc.id.to_s << '.html">' << esc.name << '</a><br>'
      fileHtml.puts lineHtml
    end

    lineHtml = '</div>'
    fileHtml.puts lineHtml

    # ES: Escenarios de evaluacion de objetivos:
    # EN: Goal Assessment Scenarios:
    lineHtml = '<div class="containerHome"><center><img src="./images/goal_b.png" style="margin:40px 0 20px 0;"></center>'
    fileHtml.puts lineHtml
    lineHtml = '<h3 style="color:#333;font-size:22px;">Goal Assessment Scenarios</h3>'   
    fileHtml.puts lineHtml

    # ES: Renderiza el link de cada escenario:
    # EN: Renders each scenario's link:
    goalIds = params[:goalIds].split("|")
    goalEsc = Escenarios::GoalEscenario.where(id: goalIds)


    goalEsc.each do |esc|
      lineHtml = '<a href="goalEscenarios/escG' << esc.id.to_s << '.html">' << esc.name << '</a><br>'
      fileHtml.puts lineHtml
    end

  	lineHtml = '</div><div class="containerHome"><center><img src="./images/sort_b.png" style="margin:40px 0 20px 0;"></center>'
  	fileHtml.puts lineHtml
    lineHtml = '<h3 style="color:#333;font-size:22px;">Prioritization Scenarios</h3>'  	
    fileHtml.puts lineHtml

    # ES: Renderiza el link de cada escenario:
    # EN: Renders each scenario's link:
    priorIds = params[:priorIds].split("|")
    priorEsc = Escenarios::PriorizationEscenario.where(id: priorIds)

    priorEsc.each do |esc|
      lineHtml = '<a href="priorizationEscenarios/escP' << esc.id.to_s << '.html">' << esc.name << '   [ ' << esc.fecha_ejecucion.to_s << ' ]</a><br>'
      fileHtml.puts lineHtml
    end

  	lineHtml = '</div></div></body></html>'
  	fileHtml.puts lineHtml
  	fileHtml.close()
  	timeFin = Time.now
  	timeExpend = (timeFin - timeInit).to_f
  	log.push("Initial page content creation finished - Time required: " << timeExpend.to_s << ' (seconds)')

    	respond_to do |format|
    		format.json {render json: log}
      end

  end

  # ES: Genera la carpeta raiz de los mapas de decision y sus hojas de estilo, y alli crea el archivo inicial: index
  # EN: Generates the decision map's root folder, and its css, and there creates the initial file: index
  def g_decision_maps
  	timeInit = Time.now
    empresa = Enterprise.find(params[:idEmp].to_i)
    log = []
    mapIds = params[:mapIds].split("%")[0]
    archIds = params[:mapIds].split("%")[1]
    mapIds.blank? ? mapIds = [] : mapIds = mapIds.split("|")
    archIds.blank? ? archIds = [] : archIds = archIds.split("|")

    # ES: Ejecuta la generacion en el engine!: Comentar si el engine no esta activo
    # EN: Execute the generation in the Engine!: Comment if the engine is not active
    # ::MAPAS::
    log2 = view_context.mapasGenerateMapsHTML(empresa, mapIds, archIds, log)
    log.concat(log2)

  	timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
  	log.push("Decision maps creation finished - Time required: " << timeExpend.to_s << ' (seconds)')

  	respond_to do |format|
  		format.json {render json: log}
    end

  end
  # ------ g_decision_maps  

  

  # ES: Genera la carpeta raiz de los escenarios de evaluación de riesgos y sus hojas de estilo, y alli crea el archivo inicial: index
  # EN: Generates the risk assessment scenario's root folder, and its css, and there creates the initial file: index
  def g_risk_escenarios
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []
    riskIds = params[:riskIds].split("|")

  	log.push("Creating risk assessment scenarios content...")

    # ::ESCENARIOS:: ES: Comentar si el engine no esta activo! - EN: Comment if the engine is not active!
    log2 = view_context.escenariosGenerateRisksHTML(empresa, riskIds,log)
    log.concat(log2)	

    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Risk assessment scenarios content creation finished - Time required: " << timeExpend.to_s << ' (seconds)')

  	respond_to do |format|
  		format.json {render json: log}
    end

  end

  
  # ES: Genera los archivos de los escenarios de evaluacion de objetivos:
  # EN: Generates the files of the goal assessment scenarios:
  def g_goal_escenarios
    timeInit = Time.now
    empresa = Enterprise.find(params[:idEmp].to_i)
    log = []
    goalIds = params[:goalIds].split("|")

    log.push("Creating goal assessment scenarios content...")

    # ::ESCENARIOS:: ES: Comentar si el engine no esta activo! - EN: Comment if the engine is not active!
    log2 = view_context.escenariosGenerateGoalsHTML(empresa, goalIds, log)
    log.concat(log2)  
    
    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Goal assessment scenarios content creation finished - Time required: " << timeExpend.to_s << ' (seconds)')

    respond_to do |format|
      format.json {render json: log}
    end


  end 
  # ============ G_GOAL_ESCENARIOS


  def g_priorization_escenarios
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []
    priorIds = params[:priorIds].split("|")

  	log.push("Creating prioritization scenarios content...")

    # ::ESCENARIOS:: ES: Comentar si el engine no esta activo! - EN: Comment if the engine is not active!
    log2 = view_context.escenariosGeneratePriorsHTML(empresa, priorIds, log)
    log.concat(log2)

    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Prioritization scenarios content creation finished - Time required: " << timeExpend.to_s << ' (seconds)')

    respond_to do |format|
      format.json {render json: log}
    end
  end
  # ------- g_priorization_escenarios


  # ES: Configura la sesion con el valor de la empresa seleccionada:
  # EN: Configure the session with the value of the selected enterprise:
  def session_config
    # ES: Crea la sesion, si el usuario está autorizado, si no, lo bloquea:
    # EN: Creates the session if the user is authorized, if not, block it:
    session[:empresa] = params[:idEmpresa].to_i;
    toRender = 'OK'

    respond_to do |format|
      format.json {render text: toRender}
    end
  end # --- SESSION_CONFIG
  
end # --- CONTROLLER
