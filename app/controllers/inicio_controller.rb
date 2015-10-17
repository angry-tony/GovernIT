#encoding: utf-8

class InicioController < ApplicationController
  require 'fileutils'

  
  def inicio
    # Las empresas se cargan según los roles del usuario: Si es evaluador, sólo carga su empresa, si es administrador, carga todas
    if current_user.has_role? ROLE_ADMIN
      @empresas = Enterprise.all  
    elsif current_user.has_role? ROLE_EVAL
      @empresas = Enterprise.all
    else
      @empresas = []
      if !current_user.enterprise.nil?
        @empresas << current_user.enterprise
      end
    end    	
  end

  # Menú de administración, para generar las aplicaciones cliente para cada empresa:
  def admin
  	@empresas = Enterprise.all
  end

  # Todo el contenido seleccionable para generar el HTML:
  def getFilterEmpresa
    empresa = Enterprise.find(params[:idEmp].to_i)
    content = []
    # El primer registro valida si la empresa tiene logo o no:
    if empresa.logo.blank?
      content[0] = 'NO_LOGO'
    else
      content[0] = 'SI_LOGO'
    end


    # Mapas de decision:
    mapasFormateados = view_context.mapasListDecisionMaps(empresa.id)
    # Agrega los mapas formateados:
    content.concat(mapasFormateados)

    # Escenarios de Evaluacion de Riesgos:
    riesgosFormateados = view_context.escenariosListRiskEscenarios(empresa.id)
    # Agrega los mapas formateados:
    content.concat(riesgosFormateados)

    # Escenarios de Evaluacion de Objetivos:
    goalsFormateados = view_context.escenariosListGoalEscenarios(empresa.id)
    # Agrega los mapas formateados:
    content.concat(goalsFormateados)

    # Escenarios de Priorizacion:
    priorsFormateados = view_context.escenariosListPriorEscenarios(empresa.id)
    # Agrega los mapas formateados:
    content.concat(priorsFormateados)

    respond_to do |format|
      format.json {render json: content}
    end
  
  end 

  # Genera la carpeta raiz de la empresa y las carpetas de imagenes y hojas de estilo, y alli crea el archivo inicial: index
  def g_home
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []


  	# Directorio actual:
  	actualFolder = Rails.root.to_s
  	Dir.chdir(actualFolder)

  	# Ruta archivo de estilos:
  	stylesRoute = actualFolder+'/app/assets/stylesheets/metro-bootstrap.css'
    stylesJqRoute = actualFolder+'/app/assets/stylesheets/my_jquery.css'
    imagesJqRoute = actualFolder+'/app/assets/stylesheets/images'
  	# Ruta de la imagen de las jerarquias:
  	rightRoute = actualFolder+'/app/assets/images/right.png'
  	# Rutas de las imagenes para la pantalla inicial:
  	mapRoute = actualFolder+'/app/assets/images/map_b.png'
  	riskRoute = actualFolder+'/app/assets/images/risk_b.png'
  	sortRoute = actualFolder+'/app/assets/images/sort_b.png'
    goalRoute = actualFolder+'/app/assets/images/goal_b.png'
    # Rutas de las imagenes de uniandes y pacific
    #uniandesRoute = actualFolder+'/app/assets/images/uniandes.png'
    #pacificRoute = actualFolder+'/app/assets/images/pacific.jpg'
    # Rutas para las imagenes del dialogo de niveles de evaluacion de riesgos:
    xAxisRoute = actualFolder+'/app/assets/images/x-axis.png'
    yAxisRoute = actualFolder+'/app/assets/images/y-axis.png'
    moneyRoute = actualFolder+'/app/assets/images/money.png'
    impTolRoute = actualFolder+'/app/assets/images/imp_tol.png'


  	# Crea la carpeta que contendrá los contenidos HTML:
  	rootFolder = 'HTML_CONTENT'
  	FileUtils.mkdir_p(rootFolder)
  	log.push("Creando contenido de la página inicial...")
  	log.push("Directorio creado: " << rootFolder << '(Directorio principal)')

  	# Actualiza el directorio actual: /HTML_CONTENT
  	actualFolder+= '/' + rootFolder
  	Dir.chdir(actualFolder)

  	# Crea la carpeta, cuyo nombre será [ID_Empresa] Nombre
  	folderName = '[' << empresa.id.to_s << '] ' << empresa.name
  	FileUtils.mkdir_p(folderName)
  	log.push("Directorio creado: " << folderName << '(Directorio de la empresa)')

  	# Actualiza el directorio actual: /HTML_CONTENT/[ID_Empresa] Nombre
  	actualFolder+= '/' + folderName
  	Dir.chdir(actualFolder)
  	rootEmpresa = actualFolder

  	# Crea la carpeta y el archivo de estilos:
  	FileUtils.mkdir_p('css')
  	log.push("Directorio creado: css (Para archivos .css)" )
  	Dir.chdir(actualFolder+"/css")
  	FileUtils.cp stylesRoute, 'styles.css'
  	#log.push("Archivo de estilos copiado: styles.css (Archivo de estilos general)")

    # Adentro copia el archivo de estilos de jquery, y su carpeta propia de imagenes:
    FileUtils.cp stylesJqRoute, 'my_jquery.css'
    FileUtils.mkdir_p('images')
    FileUtils.cp_r(Dir.glob(imagesJqRoute << '/*'), 'images')

  	# Crea la carpeta de archivos .js:
  	Dir.chdir(actualFolder)
  	FileUtils.mkdir_p('js')
  	log.push("Directorio creado: js (Para archivos JavaScript)")

  	# Crea la carpeta de imagenes, y carga la imagen para las jerarquias en los mapas
  	Dir.chdir(actualFolder)
  	FileUtils.mkdir_p('images')
  	log.push("Directorio creado: images (Para archivos .png)")
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

    #FileUtils.cp uniandesRoute, 'uniandes.png'
    # Define la ruta del logo si es necesario:
    addLogo = params[:logo]
    if addLogo == 'SI'
      logoRoute = Rails.root.to_s << '/public/system/logos/' << empresa.id.to_s << '/' << empresa.logo_file_name
      FileUtils.cp logoRoute, empresa.id.to_s << '_' << empresa.logo_file_name
    end


    #FileUtils.cp pacificRoute, 'pacific.jpg'
  	#log.push("Imagen copiada: right.png (Para las jerarquías)")

    Dir.chdir(actualFolder)
  	# Crea el archivo index:
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
    lineHtml = '<h2 style="font-size:60px;">Modelo de Gobierno de TI</h2></div><div style="margin-bottom:35px;">'
    fileHtml.puts lineHtml
    if addLogo == 'SI'
      lineHtml = '<center><img style="max-width:260px;max-height:230px;" src="./images/' << empresa.id.to_s << '_' << empresa.logo_file_name << '"></center>'
      fileHtml.puts lineHtml
    end

    lineHtml = '</div><div class="containerHome">'
  	fileHtml.puts lineHtml
  	lineHtml = '<center><img src="./images/map_b.png" style="margin:40px 0 20px 0;"></center>'
  	fileHtml.puts lineHtml
  	#lineHtml = '<a href="decisionMaps/indexMaps.html">Mapas de Decisión</a></h4></div><div class="containerHome">'
    lineHtml = '<h3 style="color:#333;font-size:22px;">Mapas de Decisión</h3>'
    fileHtml.puts lineHtml

    # Renderiza el link de cada mapa:
    #mapas = empresa.decision_maps
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
  	#lineHtml = '<a href="riskEscenarios/indexRiskEscenarios.html">Escenarios de Evaluación de Riesgos</a></h4></div>'
    lineHtml = '<h3 style="color:#333;font-size:22px;">Escenarios de Evaluación de Riesgos</h3>'
  	fileHtml.puts lineHtml

    # Renderiza el link de cada mapa:
    #riskEsc = empresa.risk_escenarios
    riskIds = params[:riskIds].split("|")
    riskEsc = Escenarios::RiskEscenario.where(id: riskIds)

    riskEsc.each do |esc|
      lineHtml = '<a href="riskEscenarios/esc' << esc.id.to_s << '.html">' << esc.name << '</a><br>'
      fileHtml.puts lineHtml
    end

    lineHtml = '</div>'
    fileHtml.puts lineHtml

    # Escenarios de evaluacion de objetivos:
    lineHtml = '<div class="containerHome"><center><img src="./images/goal_b.png" style="margin:40px 0 20px 0;"></center>'
    fileHtml.puts lineHtml
    lineHtml = '<h3 style="color:#333;font-size:22px;">Escenarios de Evaluación de Objetivos</h3>'   
    fileHtml.puts lineHtml

    # Renderiza el link de cada escenario:
    #goalEsc = empresa.goal_escenarios
    goalIds = params[:goalIds].split("|")
    goalEsc = Escenarios::GoalEscenario.where(id: goalIds)


    goalEsc.each do |esc|
      lineHtml = '<a href="goalEscenarios/escG' << esc.id.to_s << '.html">' << esc.name << '</a><br>'
      fileHtml.puts lineHtml
    end

  	lineHtml = '</div><div class="containerHome"><center><img src="./images/sort_b.png" style="margin:40px 0 20px 0;"></center>'
  	fileHtml.puts lineHtml
  	#lineHtml = '<h4 style="text-align:center;"><a href="priorizationEscenarios/indexPriorizationEscenarios.html">Escenarios de Priorización</a></h4>'
    lineHtml = '<h3 style="color:#333;font-size:22px;">Escenarios de Priorización</h3>'  	
    fileHtml.puts lineHtml

    # Renderiza el link de cada mapa:
    #priorEsc = empresa.priorization_escenarios
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
  	#log.push("Archivo creado: index.html (Inicio)")
  	log.push("Finaliza creación contenido de la página inicial - Tiempo requerido: " << timeExpend.to_s << ' (segundos)')

    	respond_to do |format|
    		format.json {render json: log}
      end

  end

  # Genera la carpeta raiz de los mapas de decision y sus hojas de estilo, y alli crea el archivo inicial: index
  def g_decision_maps
  	timeInit = Time.now
    empresa = Enterprise.find(params[:idEmp].to_i)
    log = []
    mapIds = params[:mapIds].split("%")[0]
    archIds = params[:mapIds].split("%")[1]
    mapIds.blank? ? mapIds = [] : mapIds = mapIds.split("|")
    archIds.blank? ? archIds = [] : archIds = archIds.split("|")

    # Ejecuta la generacion en el engine!: Comentar si el engine no esta activo
    # ::MAPAS::
    log2 = view_context.mapasGenerateMapsHTML(empresa, mapIds, archIds, log)
    log.concat(log2)

  	timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
  	log.push("Finaliza creación contenido mapas de decisión - Tiempo requerido: " << timeExpend.to_s << ' (segundos)')

  	respond_to do |format|
  		format.json {render json: log}
    end

  end
  # ------ g_decision_maps  

  

  # Genera la carpeta raiz de los escenarios de evaluación de riesgos y sus hojas de estilo, y alli crea el archivo inicial: index
  def g_risk_escenarios
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []
  	#escenarios = empresa.risk_escenarios
    riskIds = params[:riskIds].split("|")

  	log.push("Creando contenido de los escenarios de evaluación de riesgos...")

    # ::ESCENARIOS:: Comentar si el engine no esta activo!
    log2 = view_context.escenariosGenerateRisksHTML(empresa, riskIds,log)
    log.concat(log2)	

    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Finaliza creación contenido escenarios de evaluación de riesgos - Tiempo requerido: " << timeExpend.to_s << ' (segundos)')

  	respond_to do |format|
  		format.json {render json: log}
    end

  end

  
  # Genera los archivos de los escenarios de evaluacion de objetivos:
  def g_goal_escenarios
    timeInit = Time.now
    empresa = Enterprise.find(params[:idEmp].to_i)
    log = []
    goalIds = params[:goalIds].split("|")

    log.push("Creando contenido de los escenarios de evaluación de objetivos...")

    # ::ESCENARIOS:: Comentar si el engine no esta activo!
    log2 = view_context.escenariosGenerateGoalsHTML(empresa, goalIds, log)
    log.concat(log2)  
    
    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Finaliza creación contenido escenarios de evaluación de objetivos - Tiempo requerido: " << timeExpend.to_s << ' (segundos)')

    respond_to do |format|
      format.json {render json: log}
    end


  end 
  # ============ CIERRA G_GOAL_ESCENARIOS


  def g_priorization_escenarios
  	timeInit = Time.now
  	empresa = Enterprise.find(params[:idEmp].to_i)
  	log = []
  	#escenarios = empresa.priorization_escenarios
    priorIds = params[:priorIds].split("|")

  	log.push("Creando contenido de los escenarios de priorización...")

    # ::ESCENARIOS:: Comentar si el engine no esta activo!
    log2 = view_context.escenariosGeneratePriorsHTML(empresa, priorIds, log)
    log.concat(log2)

    timeFin = Time.now
    timeExpend = (timeFin - timeInit).to_f
    log.push("Finaliza creación contenido escenarios de priorización - Tiempo requerido: " << timeExpend.to_s << ' (segundos)')

    respond_to do |format|
      format.json {render json: log}
    end
  end
  # ------- g_priorization_escenarios

  def modulos
    accesos = [false, false, false, false]

    if !current_user.nil?
      # Está logueado
      if current_user.has_role? ROLE_ADMIN
        accesos = [true, true, true, true]
      elsif current_user.has_role? ROLE_EVAL
        accesos = [true, true, true, true]
      else
		  if current_user.has_role? ROLE_USER_CONFIG
        accesos[0] = true
		  end
		  if current_user.has_role? ROLE_USER_GOV
			  accesos[1] = true
		  end	
		  if current_user.has_role? ROLE_USER_SIMULATION
			  accesos[2] = true
		  end
		  if current_user.has_role? ROLE_USER_QUANTIFY
			  accesos[3] = true
		  end 
	  end

    end

    respond_to do |format|
      format.json {render json: accesos}
    end

  end # FIN MODULOS

  # Configura la sesion con el valor de la empresa seleccionada:
  def session_config
    # Antes de crear la sesion, verifica que el usuario pueda tener acceso a esa empresa:
    autorizado = true
    if !current_user.enterprise.nil?
      # Está limitado a una sola empresa, verifica que sea esa la que llego como parametro:
      if params[:idEmpresa].to_i != current_user.enterprise.id
        # No tiene acceso
        autorizado = false
      end
    end

    # Crea la sesion, si el usuario está autorizado, si no, lo bloquea:
    if autorizado
      user_session[:empresa] = params[:idEmpresa].to_i;
      toRender = 'OK'
    else
      toRender = 'ERROR'
    end

    respond_to do |format|
      format.json {render text: toRender}
    end
  end # FIN SESSION_CONFIG
  
end # FIN DEL CONTROLLER
