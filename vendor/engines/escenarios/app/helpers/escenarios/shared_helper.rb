#encoding: utf-8
module Escenarios
  module SharedHelper
  	# ES: Helper que puede ser utilizado desde la aplicacion principal.
  	# EN: Helper that could be used FROM the main application

    # ES: Helper para listar y formatear los escenarios de evaluacion de riesgos
    # EN: Helper to list and format the risk assessment scenarios
  	def escenariosListRiskEscenarios(empId)
  		content = []
  		risks = RiskEscenario.where(enterprise_id: empId)
	    # ES: Inserta un registro de separacion:
	    # EN: Inserts a separation record:
	    content.push('Risk Assessment Scenarios$:$' << risks.size.to_s)

	    risks.each do |risk|
	      # String: ID_RISK|name
	      string = risk.id.to_s << '_RISK|' << risk.name
	      content.push(string)
	    end

	    content
  	end
  	# ---------

  	# ES: Helper para listar y formatear los escenarios de evaluacion de objetivos
  	# EN: Helper to list and format the goal assessment scenarios
  	def escenariosListGoalEscenarios(empId)
  		content = []
  		goals = GoalEscenario.where(enterprise_id: empId)
	    # ES: Inserta un registro de separacion:
	    # EN: Inserts a separation record:
	    content.push('Goal Assessment Scenarios$:$' << goals.size.to_s)

	    goals.each do |goal|
	      # String: ID_GOAL|name
	      string = goal.id.to_s << '_GOAL|' << goal.name
	      content.push(string)
	    end

	    content
  	end
  	# ---------

  	# ES: Helper para listar y formatear los escenarios de priorizacion
  	# EN: Helper to list and format the prioritization scenarios
  	def escenariosListPriorEscenarios(empId)
  		content = []
  		priors = PriorizationEscenario.where(enterprise_id: empId)
	    # ES: Inserta un registro de separacion:
	    # EN: Inserts a separation record:
	    content.push('Prioritization Scenarios$:$' << priors.size.to_s)

	    priors.each do |prior|

	      escTemp = priors.select{|e| (e.risk_escenario.id == prior.risk_escenario.id) && (e.goal_escenario.id == prior.goal_escenario.id)}
	      priors = priors - escTemp

	      escTemp.each_with_index do |e, index|
	        if index > 0
	          # ES: Se debe identar
	          # EN: It must be indented
	          # String: ID_PRIOR|name
	          string = e.id.to_s << '_PRIOR|' << e.name << '|I'
	        else
	          # Normal
	          # String: ID_PRIOR|name
	          string = e.id.to_s << '_PRIOR|' << e.name
	        end

	        content.push(string)
	      end # each_with_index
	      
	    end # priors.each do

	    content
  	end
  	# ---------

  	# ES: Helper que genera todo el contenido HTML de los escenarios de evaluacion de riesgos:
  	# EN: Helper that generates all the HTML content of the risk assessment scenarios:
  	def escenariosGenerateRisksHTML(empresa, riskIds, log)
  		escenarios = RiskEscenario.where(id: riskIds)
  		# ES: Directorio actual: (El de la empresa)
  		# EN: Current directory: (Owned by the enterprise)
	  	actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	  	Dir.chdir(actualFolder)
	  	rootEmpresa = actualFolder

	  	# ES: Crea la carpeta para los escenarios de riesgo y su respectivo archivo index:
	  	# EN: Creates the folder to store the risk assessment scenarios and its respective index file:
	  	folderName = 'riskEscenarios'
	  	FileUtils.mkdir_p(folderName)
	  	log.push("Directory created: riskEscenarios (Risk Assessment Scenarios)")

	    # ES: Crea el archivo de estilos para los mapas de decision:
	    # EN: Creates the css file for the decision maps:
	    Dir.chdir(rootEmpresa+"/css")
	    riskStyles = 'riskStyles.css'
	    fileHtml = File.new(riskStyles, "w")
	    lineHtml = 'td.riskmap{  border: 1px solid white;  width:40px;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'span#showRiskScaleHTML{cursor:pointer;margin-left:15px;font-size:15px;color:#428bca;}'
	    fileHtml.puts lineHtml

	    fileHtml.close()
	    log.push("File created: riskStyles.css")

	    # ES: Crea el archivo de js para el dialogo en los escenarios de riesgo:
	    # EN: Creates the js file for the dialog in the risk assessment scenarios:
	    Dir.chdir(rootEmpresa+"/js")
	    riskJs = Rails.root.to_s << '/app/assets/javascripts/riskJS.js'
	    FileUtils.cp riskJs, 'riskJS.js'

	  	Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta riskEscenarios - EN: Enters the folder 
	  	# ES: Crea el archivo index para los escenarios de evaluacion de riesgos:
	  	# EN: Creates the index file for the risk assessment scenarios:
	  	fileHtml = File.new("indexRiskEscenarios.html", "w")
	  	lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" type="text/css" href="../css/styles.css"/></head>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<body><div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<li class="active">['<< empresa.name << '] IT Governance - Risk Assessment Scenarios</li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '</ol></div>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<h2>Risk Assessment Scenarios:</h2>'
	  	fileHtml.puts lineHtml
	  	if escenarios.size == 0
	  		lineHtml = '<div class="alert alert-info">'
	  		fileHtml.puts lineHtml
	  		lineHtml = 'No risk assessment scenarios in the system, for the enterprise: '<< empresa.name << '.' << '</div>'
	  		fileHtml.puts lineHtml
	  	else
	  		escenarios.each do |e|
	        strName = e.governance_structure
	        if strName.nil?
	          strName = 'System-Generated Scenario'
	        else
	          strName = e.governance_structure.name
	        end
	  			lineHtml = '<a href="esc' << e.id.to_s << '.html"> [' << strName << '] - ' << e.name << '</a><br>'
	  	    fileHtml.puts lineHtml
	  		end
	  	end

	  	lineHtml = '</body></html>'
	    fileHtml.puts lineHtml

	  	fileHtml.close()
	  	log.push("File created: riskEscenarios.html")


	    # ES: Crea el archivo de cada escenario de riesgos:
	    # EN: Creates the file for each risk assessment scenario:
	    risksGen = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
	    hijosGen = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, empresa.id)
	    riskmap = empresa.configuracion
	    categories = RiskCategory.where("id_padre IS NULL")
	    # ES: Si no encuentra la configuración, la envía vacía:
	    # EN: If there is no configuration, send it empty:
	  	if riskmap.nil?
		    # ES: Envía en los niveles, los valores por defecto
		    # EN: Send in the levels, the default values
		    default = RISK_SCALE   
		    niveles = default.split('|')
	  	else
		    if riskmap.riskmap.nil? or riskmap.riskmap.empty?
		      # ES: Envía en los niveles, los valores por defecto
		      # EN: Send in the levels, the default values
		      default = RISK_SCALE   
		      niveles = default.split('|')
		    else
		      niveles = riskmap.riskmap.split('|')
		    end
		end

		# ES: Genera el archivo de cada escenario de evaluacion de riesgos:
		# EN: Generates the file for each risk assessment scenarios:
		escenarios.each do |esc|
			# ES: Calificaciones:
			# EN: Scores:
	    	cals = esc.califications

	    	nameFile = 'esc' << esc.id.to_s << '.html'
	    	fileHtml = File.new(nameFile, "w")
	  		lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
	  		fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/riskStyles.css"/>'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" href="../css/my_jquery.css" />'
			fileHtml.puts lineHtml  
			lineHtml = '<script src="http://code.jquery.com/jquery-1.10.2.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="http://code.jquery.com/ui/1.11.0/jquery-ui.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="../js/riskJS.js"></script>'
			fileHtml.puts lineHtml
	  		lineHtml = '</head><body>'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<li class="active">[' << empresa.name << '] Risks Assessment: ' << esc.name << '</li></ol></div>'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<h2>Scenario: ' << esc.name << '<span id="showRiskScaleHTML" title="Show risk assessment scale">Show risk assessment scale</span></h2>'
	  		fileHtml.puts lineHtml

	  		categories.each do |cat|
	  			lineHtml = '<div class="alert alert-info"><span style="font-size:18px;">Risk Category: ' << cat.description << '</span></div>'
				fileHtml.puts lineHtml

				myRisks = risksGen.select{|r| r.risk_category.id_padre == cat.id}

				myRisks.each do |risk|
					lineHtml = '<div style="width:100%;height:40px;margin-top:10px;" >'
					fileHtml.puts lineHtml
					calGen = cals.select { |cal|  cal.risk == risk  }.first
					lineHtml = '<div style="float:left;width:3%;"><span style="width:35px;height:25px;margin-right:5px;'
					fileHtml.puts lineHtml
					lineHtml = 'border:solid 2px #4A8AFA;display:inline-block;" title="Average score of its specific risks">'
					fileHtml.puts lineHtml

					if !calGen.nil?
						lineHtml = '&nbsp;&nbsp;' << calGen.valor.to_s << '</span></div>'
					else
						lineHtml = '&nbsp;&nbsp;-</span></div>'	
					end

					fileHtml.puts lineHtml	
					lineHtml = '<div style="float:left;width:96%;margin-left:1%;">'
					fileHtml.puts lineHtml	
					lineHtml = '<div style="float:left;width:100%;">'
					fileHtml.puts lineHtml

					lineHtml = '<span style="padding-top:2px;">' << risk.descripcion << '</span></div></div></div>'
					fileHtml.puts lineHtml

					# ES: Renderiza los hijos también:
					# EN: Renders also the sons:
					hijos = hijosGen.select{|h| h.riesgo_padre_id == risk.id}

					if hijos.size > 0

						hijos.each do |h|
							# ES: Revisa si tiene calificacion ese riesgo:
							# EN: Checks if that risk has related scores:
							myCal = cals.select {|cal| cal.risk == h }.first
							if myCal.nil?
								# ES: No calificado
								# EN: Not scored
								lineHtml = '<p style="margin-left:4%;color:#333;"><span style="width:35px;height:20px;margin-right:5px;'
								fileHtml.puts lineHtml
								lineHtml = 'border:solid 1px #333;display:inline-block;">&nbsp;-</span>'
								fileHtml.puts lineHtml
								lineHtml = '<i>- ' << h.descripcion << '</i></p>'
								fileHtml.puts lineHtml
							else
								# ES: Calificado
								# EN: Scored
								cont = 0
					            niveles.each do |nivel|
					              cont+= 1
					              if nivel.to_i == myCal.valor.to_i
					                break
					              end
					            end

					            color = 'yellow'
					            importancia = 'Medium/Tolerable'
					            
					            if cont == 19 || cont == 25 || cont == 26 || cont == 31 || cont == 32 || cont == 33 
					                # ES: VERDE - EN: GREEN  
					               color = 'green'
					               importancia = 'Low/Acceptable'
					            elsif cont == 4 || cont == 5 || cont == 6 || cont == 11 || cont == 12 || cont == 18 
					              # ES: ROJO - EN: RED
					              color = 'red'
					              importancia = 'Highest/Inadmissible'
					            elsif cont == 2 || cont == 3 || cont == 9 || cont == 10 || cont == 16 || cont == 17 || cont == 23 || cont == 24 || cont == 30
					               # ES: NARANJA - EN: ORANGE 
					               color = 'orange'
					               importancia = 'High/Unacceptable'
					            end

					            if myCal.risk_type.nil?
					            	r_t = 'Undefined'
					            else
					            	r_t = myCal.risk_type
					            end

					            if myCal.evidence.nil? || myCal.evidence.blank?
					            	evi = 'Undefined'
					            else
					            	evi = myCal.evidence
					            end

					            lineHtml = '<p style="margin-left:4%;color:#333;"><span style="background-color:' << color << ';width:35px;'
					            fileHtml.puts lineHtml
					            lineHtml = 'height:20px;margin-right:5px;border:solid 1px #333;display:inline-block;color:black;" >&nbsp;&nbsp;' << myCal.valor.to_s
					            fileHtml.puts lineHtml
					            lineHtml = '</span><i>- ' << h.descripcion << '</i><br><span style="font-size:12px;color:#AAA;">'
					            fileHtml.puts lineHtml
					            lineHtml = '<i>Financial Impact: ' << myCal.cantidad.to_s << ' (USD), Risk Type: ' << r_t << ',' 
					            fileHtml.puts lineHtml
					            lineHtml = 'Importance/Tolerance: ' << importancia << ', Evidence: ' << evi << '</i></span></p>'
					            fileHtml.puts lineHtml 						
							end # ES: Cierra calificado - EN: Close calificado

						end # ES: Cierra hijos - EN: Close sons

					end # ES: Cierra hijos.size > 0 - EN: Close hijos.size > 0
				end
				# ------ myRisks.each do
	  		end
	  		# ----- categories.each do

	  		colores = ["yellow", "orange", "orange", "red", "red", "red",
               "yellow", "yellow", "orange", "orange", "red", "red",
               "yellow", "yellow", "yellow", "orange", "orange", "red",
               "green", "yellow", "yellow", "yellow", "orange", "orange",
               "green", "green", "yellow", "yellow", "yellow", "orange",
               "green", "green", "green", "yellow", "yellow", "yellow"]

		    lineHtml = '<div id="dialogRiskScale" title="Risk assessment scale"><div style="width:100%;"><div style="float:left;width:130px;">'
		    fileHtml.puts lineHtml
		    lineHtml = '<img src="../images/y-axis_en.png" style="margin-top:35px;"></div><div style="float:left;width:240px;">'
		    fileHtml.puts lineHtml
		    lineHtml = '<table style="margin-top:20px;color:black;text-align:center;font-size:13px;">'
		    fileHtml.puts lineHtml

		    for k in 0..35

		      if (k == 0)
		        lineHtml = '<tr style="border: 1px solid white;height:40px;">'
		        fileHtml.puts lineHtml
		      elsif (k == 6 || k == 12 || k == 18 || k == 24 || k == 30)
		        lineHtml = '</tr><tr style="border: 1px solid white;height:40px;">'
		        fileHtml.puts lineHtml
		      end

		      lineHtml = '<td class="riskmap" style="background:' << colores[k] << ';">' << niveles[k] << '</td>'
		      fileHtml.puts lineHtml
		    end

		    lineHtml = '</tr></table></div><div style="float:left;width:220px;"><img src="../images/imp_tol_en.png" style="margin:17px 0 10px 55px">'
		    fileHtml.puts lineHtml
		    lineHtml = '<img align="left" src="../images/money.png" style="width:30px;height:30px;margin: 10px 5px 0 70px;">'
		    fileHtml.puts lineHtml
		    lineHtml = '<p style="font-size:11px;width:70%;margin-left:45%;">Financial impact (aprox.) per risk unit (USD):</p></img>'
		    fileHtml.puts lineHtml
		    lineHtml = '<input type="number" style="margin:8px 0 10px 70px;width:150px;" min="0" disabled value="' << niveles[36] << '"></div>'
		    fileHtml.puts lineHtml
		    lineHtml = '</div><div style="width:100%;"><img src="../images/x-axis_en.png" style="margin:9px 0 0 130px;"></div></div>'
		    fileHtml.puts lineHtml

			lineHtml = '</body></html>'
		    fileHtml.puts lineHtml
		    fileHtml.close()

		end 
		# ----- escenarios.each do

		# ES: Devuelve el arreglo del log actualizado
		# EN: Returns the log array updated
		return log
  	end
  	# --------- escenariosGenerateRisksHTML


  	# ES: Helper para generar el contenido HTML de los escenarios de evaluacion de objetivos:
  	# EN: Helper to generate the HTML content of the goals assessments scenarios:
  	def escenariosGenerateGoalsHTML(empresa, goalIds, log)
  		escenarios = GoalEscenario.where(id: goalIds)
  		# ES: Directorio actual: (El de la empresa)
  		# EN: Current directory: (owned by the enterprise)
	    actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	    Dir.chdir(actualFolder)
	    rootEmpresa = actualFolder

	    # ES: Crea el archivo de js para la interaccion con pestañas:
	    # EN: Creates the js file to support the tabs interaction:
	    Dir.chdir(rootEmpresa+"/js")
	    goalJs = Rails.root.to_s << '/app/assets/javascripts/goalJS.js'
	    FileUtils.cp goalJs, 'goalJS.js'

	    Dir.chdir(rootEmpresa)

	    # ES: Crea la carpeta para los escenarios de objetivos:
	    # EN: Creates the folder for the goals scenarios:
	    folderName = 'goalEscenarios'
	    FileUtils.mkdir_p(folderName)
	    log.push("Directory created: goalEscenarios (Goal Assessment Scenarios)")
	    Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta goalEscenarios - EN: Enters the folder goalScenarios


	    # ES: Crea el archivo de cada escenario de evaluacion de objetivos:
	    # EN: Creates the file for each goal assessment scenario:

	    # ES: Variables comunes a todos los escenarios:
	    # EN: Common variables to all scenarios:

	    # ES: Objetivos de Negocio:
	    # EN: Business Goals:
	    bGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL)
	    # ES: Objetivos de TI:
	    # EN: IT Goals:
	    itGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL)
	    # ES: Dimensiones:
	    # EN: Dimensions:
	    it_dims = itGoals.map { |goal| goal.dimension }.uniq
	    b_dims = bGoals.map { |goal| goal.dimension }.uniq
	    # ES: Especificos:
	    # EN: Specific:
	    especificos = Goal.where("goal_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, empresa.id)

	    # ES: Genera el archivo de cada escenario de evaluacion de objetivos
	    # EN: Generates the file for each goal assessment scenario
	    escenarios.each do |esc|
	    	cals = esc.goal_califications
			nameFile = 'escG' << esc.id.to_s << '.html'
			fileHtml = File.new(nameFile, "w")
			lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" href="../css/my_jquery.css" />'
			fileHtml.puts lineHtml  
			lineHtml = '<script src="http://code.jquery.com/jquery-1.10.2.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="http://code.jquery.com/ui/1.11.0/jquery-ui.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="../js/goalJS.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '</head><body>'
			fileHtml.puts lineHtml
			lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
			fileHtml.puts lineHtml
			lineHtml = '<li class="active">[' << empresa.name << '] Goal Assessment: ' << esc.name << '</li></ol></div>'
			fileHtml.puts lineHtml
			lineHtml = '<h2>Scenario: ' << esc.name << '</h2>'
			fileHtml.puts lineHtml
			lineHtml = '<ul class="nav nav-pills"><li class="active" id="pill_b_generated"><a>Business Goals</a></li>'
			fileHtml.puts lineHtml
			lineHtml = '<li id="pill_it_generated" style="cursor:pointer;"><a>IT Goals</a></li></ul>'
			fileHtml.puts lineHtml
			lineHtml = '<div id="business_goals" style="border:solid 1px #DDD;min-height:500px;padding:10px;overflow:auto;">'
			fileHtml.puts lineHtml

			# ES: Recorre las dimensiones de negocio:
			# EN: Go over business dimensions:
			b_dims.each do |dim|

				lineHtml = '<div class="alert alert-info"><span style="text-align:center;font-size:18px;">'
				fileHtml.puts lineHtml
				lineHtml = 'Dimension: ' << dim << '</span></div>'
				fileHtml.puts lineHtml

				temp_goals = bGoals.select { |goal|  goal.dimension == dim  }
				if temp_goals.size == 0
				  lineHtml = '<p>No business goals under this dimension.</p>'
				  fileHtml.puts lineHtml
				else
				  temp_goals.each do |goal|
				    lineHtml = '<div style="width:95%;margin-left:1%;">' << goal.description
				    fileHtml.puts lineHtml

				    myCal = cals.select { |cal|  cal.goal == goal  }.first
				    if myCal.nil?
				      lineHtml = '<br><br>'
				      fileHtml.puts lineHtml
				    else
				      lineHtml = '<div class="alert alert-success" style="width:378px;margin-left:1%;margin-bottom:10px;padding: 5px 15px 5px 15px;">'
				      fileHtml.puts lineHtml
				      lineHtml = '<label>Current score: </label> Importance: '
				      fileHtml.puts lineHtml
				      
				      if myCal.importance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.importance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = ', Performance: '
				      fileHtml.puts lineHtml

				      if myCal.performance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.performance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = '</div>'
				      fileHtml.puts lineHtml

				    end # myCal.nil?

				    # ES: Renderiza sus hijos:
				    # EN: Renders their sons:
				    hijos = especificos.select{|esp| esp.parent_id == goal.id}
				    hijos.each do |hijo|
				      lineHtml = '<p style="margin-left:1%;color:#AAA;"><i>- ' << hijo.description << '</i>'
				      fileHtml.puts lineHtml
				    end

				    lineHtml = '</div>'
				    fileHtml.puts lineHtml

				  end # ES: Objetivos bajo esa dimension - EN: Goals under that dimension
				end # ES: tiene objetivos bajo esta dimension? - EN: is there goals under this dimension?
			end # ES: Dimensiones de negocio - EN: Business dimensions

			lineHtml = '</div>'
			fileHtml.puts lineHtml 

			lineHtml = '<div id="it_goals" style="display:none;border:solid 1px #DDD;min-height:500px;padding:10px;overflow:auto;">'
			fileHtml.puts lineHtml

			# ES: Agrupa por dimension:
			# EN: Groups by dimension:
			it_dims.each do |dim|
				lineHtml = '<div class="alert alert-info"><span style="text-align:center;font-size:18px;">'
				fileHtml.puts lineHtml 
				lineHtml = 'Dimension: ' << dim << '</span></div>'
				fileHtml.puts lineHtml 

				temp_goals = itGoals.select { |goal|  goal.dimension == dim  }

				if temp_goals.size == 0
				  lineHtml = '<p>No IT goals under this dimension.</p>'
				  fileHtml.puts lineHtml
				else

				  temp_goals.each do |goal|

				    lineHtml = '<div style="width:95%;margin-left:1%;">' << goal.description
				    fileHtml.puts lineHtml

				    myCal = cals.select { |cal|  cal.goal == goal  }.first
				    if myCal.nil?
				      lineHtml = '<br><br>'
				      fileHtml.puts lineHtml
				    else
				      lineHtml = '<div class="alert alert-success" style="width:378px;margin-left:1%;margin-bottom:10px;padding: 5px 15px 5px 15px;">'
				      fileHtml.puts lineHtml
				      lineHtml = '<label>Current score: </label> Importance: '
				      fileHtml.puts lineHtml
				      
				      if myCal.importance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.importance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = ', Performance: '
				      fileHtml.puts lineHtml

				      if myCal.performance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.performance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = '</div>'
				      fileHtml.puts lineHtml

				    end # myCal.nil?

				    # ES: Renderiza sus hijos:
				    # EN: Renders their sons:
				    hijos = especificos.select{|esp| esp.parent_id == goal.id}
				    hijos.each do |hijo|
				      lineHtml = '<p style="margin-left:1%;color:#AAA;"><i>- ' << hijo.description << '</i>'
				      fileHtml.puts lineHtml
				    end

				    lineHtml = '</div>'
				    fileHtml.puts lineHtml
				    
				  end # ES: Objetivos - EN: Goals
				end # ES: Objetivos de TI bajo esta dimension? - EN: IT Goals under this dimension?
			end # ES: Dimensiones de TI - EN: IT dimensions

			lineHtml = '</div>'
			fileHtml.puts lineHtml

			lineHtml = '</body></html>'
			fileHtml.puts lineHtml
			fileHtml.close()
	    end
	    # ---- escenarios.each do

	    # ES: Devuelve el log actualizado
	    # EN: Returns the updated log
	    return log

  	end
  	# ------ escenariosGenerateGoalsHTML

  	# ES: Helper que genera el contenido HTML de los escenarios de priorizacion:
  	# EN: Helper that generates the HTML content of the prioritization scenarios
  	def escenariosGeneratePriorsHTML(empresa, priorIds, log)
  		escenarios = PriorizationEscenario.where(id: priorIds)
  		# ES: Directorio actual: (El de la empresa)
  		# EN: Current directory: (owned by the enterprise)
	  	actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	  	Dir.chdir(actualFolder)
	  	rootEmpresa = actualFolder

	  	# ES: Crea la carpeta para los escenarios de priorización y su respectivo archivo index:
	  	# EN: Creates the folder for the prioritization scenarios and its index file
	  	folderName = 'priorizationEscenarios'
	  	FileUtils.mkdir_p(folderName)
	  	log.push("Directory created: prioriozationEscenarios (Prioritization Scenarios)")
	  	Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta priorizationEscenarios - EN: Enters into the foler prioritizationScenarios
	  	# ES: Crea el archivo index para los escenarios de priorizacion:
	  	# EN: Creates the index file for the prioritization scenarios:
	  	fileHtml = File.new("indexPriorizationEscenarios.html", "w")
	  	lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
	  	fileHtml.puts lineHtml
	    lineHtml = '<link rel="stylesheet" type="text/css" href="../css/priorizationStyles.css"/></head>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<body><div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<li class="active">['<< empresa.name << '] IT Governance - Prioritization Scenarios</li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '</ol></div>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<h2>Prioritization Scenarios:</h2>'
	  	fileHtml.puts lineHtml

	  	if escenarios.size == 0
	  		lineHtml = '<div class="alert alert-info">'
	  		fileHtml.puts lineHtml
	  		lineHtml = 'No prioritization scenarios, in the system for the enterprise: '<< empresa.name << '.' << '</div>'
	  		fileHtml.puts lineHtml
	  	else
			escenarios.each do |e|
				porcRiesgos = getPorcentajeRiesgos(e.risk_escenario)
			  	porcObjs = getPorcentajeObjetivos(e.goal_escenario)
				lineHtml = '<p><span>Scenario: <a href="escP' << e.id.to_s << '.html">' << e.name << '</a></span><br>'
				fileHtml.puts lineHtml
				lineHtml = '<span class="info"><i>[Completed: ' << porcRiesgos.to_s << ' %] Risk Assessment Scenario: ' << e.risk_escenario.name << ', Risks Weight: ' << e.risksWeight.to_s << '</i></span><br>'
				fileHtml.puts lineHtml
				lineHtml = '<span class="info"><i>[Completed: ' << porcObjs.to_s << ' %] Goal Assessment Scenario: ' << e.goal_escenario.name << ', Goals Weight: ' << e.goalsWeight.to_s << '</i></span><br></p>' 
	            fileHtml.puts lineHtml
			end
		end
		# --- escenarios.size == 0

		lineHtml = '</body></html>'
	    fileHtml.puts lineHtml

		fileHtml.close()
		log.push("File created: indexPriorizationEscenarios.html")

		# ES: CRea el archivo de estilos para los mapas de decision:
		# EN: Creates the css file for the decision maps:
		Dir.chdir(rootEmpresa+"/css")
		priorizationStyles = 'priorizationStyles.css'
		fileHtml = File.new(priorizationStyles, "w")
		lineHtml = 'span.info{color:#AAA;font-size:13px;}'
		fileHtml.puts lineHtml
		lineHtml = 'span.title{font-weight:bold;font-size:15px;}'
		fileHtml.puts lineHtml
		lineHtml = 'table{font-size:12px;border:solid 1px #333;padding:2px;}'
		fileHtml.puts lineHtml
		lineHtml = 'tr{border:solid 1px #333;padding:2px;}td{border:solid 1px #333;font-size:13px;font-style:italic;padding:2px;}'
		fileHtml.puts lineHtml
		lineHtml = 'th{border:solid 1px #333;background-color:#EEE;padding:10px;text-align:center;}td.centered{text-align:center;}'
		fileHtml.puts lineHtml

		fileHtml.close()
		log.push("File created: priorizationStyles.css")

		Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta priorizationEscenarios - EN: Enters into the folder prioritizationEscenarios

		# ES: Crea el archivo de la priorizacion de cada escenario:
		# EN: Creates the file for each prioritization scenarios:
		escenarios.each do |esc|
			nameFile = 'escP' << esc.id.to_s << '.html'
		    fileHtml = File.new(nameFile, "w")
			lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/priorizationStyles.css"/>'
			fileHtml.puts lineHtml
			lineHtml = '</head><body>'
			fileHtml.puts lineHtml
			lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
			fileHtml.puts lineHtml
			lineHtml = '<li class="active">[' << empresa.name << '] Prioritization: ' << esc.name << '</li></ol></div>'
			fileHtml.puts lineHtml
			lineHtml = '<h2>Scenario: ' << esc.name << '    [ ' << esc.fecha_ejecucion.to_s << ' ]' << '</h2>'
			fileHtml.puts lineHtml
		    toFormat = esc.stats.split("_$$_")
		    stats = []
		    # ES: Primera posicion, el nombre del escenario:
		    # EN: First position, scenario's name
		    stats[0] = esc.name << '    [ ' << esc.fecha_ejecucion.to_s << ' ]'
		    # ES: Segunda posicion, el peso de los riesgos:
		    # EN: Second position, risks weight
		    stats[1] = esc.risksWeight.to_s
		    # ES: Tercera posicion, el peso de los objetivos:
		    # EN: Third position, goals weight:
		    stats[2] = esc.goalsWeight.to_s

		    # ES: Formatea todos los stats, obteniendo la informacion adicional requerida de los procesos:
		    # EN: Format all the stats, getting required additional info from the processes:
		    procesos = ItProcess.all

		    # ES: Cada linea debe ir: ID_Proceso_Fuente|Descripcion|importancia_riesgos|importancia_objetivos|importancia_total
		    # EN: Each line must go: Source_Process_ID|Description|risks_importance|goals_importance|total_importance
		    toFormat.each do |line|
		      split = line.split("|")
		      idProceso = split[0].to_i
		      proceso = procesos.select{|p| p.id == idProceso}.first
		      newLine = proceso.id_fuente << '|' << proceso.description << '|' << split[1] << '|' << split[2] << '|' << split[3]
		      stats.push(newLine)
		    end

		    # ES: Imprime la tabla:
		    # EN: Prints the table:
			lineHtml = '<table style="font-size:13px;"><tr><th>Process ID</th><th>Description</th>'
			fileHtml.puts lineHtml
			escalaRisk = ( ( esc.risksWeight / 100.0 ) * 5.0).round(2).to_s
			escalaGoal = ( ( esc.goalsWeight / 100.0 ) * 5.0).round(2).to_s

			lineHtml = '<th>Risk Importance <br> (' << stats[1] << '%)<br><span style="font-size:10px;color:blue;font-style:italic;">[ Scale: 0 - ' <<  escalaRisk << ' ]</span></th>'
			fileHtml.puts lineHtml
			lineHtml = '<th>IT Goal Importance <br> (' << stats[2] << '%)<br><span style="font-size:10px;color:blue;font-style:italic;">[ Scale: 0 - ' <<  escalaGoal << ' ]</span></th>'
			fileHtml.puts lineHtml
			lineHtml = '<th>Global Importance<br><span style="font-size:10px;color:blue;font-style:italic;">[ Scale: 0 - 5 ]</span></th><th>Order</th></tr>'
			fileHtml.puts lineHtml

			limit = stats.size - 1

			for i in 3..limit
		    	idProceso = stats[i].split("|")[0]
		    	descProceso = stats[i].split("|")[1]
			  	riskI = stats[i].split("|")[2]
			  	goalI = stats[i].split("|")[3]
			  	totalI = stats[i].split("|")[4]
			  	lineHtml = '<tr><td class="centered">' << idProceso << '</td>'
			  	fileHtml.puts lineHtml
			  	lineHtml = '<td>' << descProceso << '</td><td class="centered">' << riskI << '</td>'
			  	fileHtml.puts lineHtml
			  	lineHtml = '<td class="centered">' << goalI << '</td><td class="centered">' << totalI << '</td>'
			  	fileHtml.puts lineHtml
			  	lineHtml = '<td class="centered">' << (i-2).to_s << '</td></tr>'
			  	fileHtml.puts lineHtml
		    end

		    lineHtml = '</table>'
			fileHtml.puts lineHtml
			fileHtml.close()
		end
		# --- escenarios.each do

		# ES: Devuelve el log actualizado:
		# EN: Returns the updated log
		return log
  	end
  	# ----- escenariosGeneratePriorsHTML

  	# ES: Metodo que calcula el porcentaje de completitud de un escenario de riesgos
  	# EN: Method that calculates the completeness percentage of a risk assessment scenarios
	def getPorcentajeRiesgos(riskEscenario)
		totalHijos = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, riskEscenario.enterprise.id).map{|h| h.id}
		total = totalHijos.size
		calificados = RiskCalification.where(risk_escenario_id: riskEscenario.id, risk_id: totalHijos).size

		if total == 0
			resp = 0.0
		else
			resp = ((calificados.to_f / total.to_f) * 100).round(2)
		end

		return resp
	end
	# ------

	# ES: Metodo que calcula el porcentaje de completitud de un escenario de objetivos
	# EN: Method that calculates the completeness percentage of a goal assessment scenario
	def getPorcentajeObjetivos(goalEscenario)
		total = Goal.where("goal_type = ?", GENERIC_TYPE).size  	
		calificados = goalEscenario.goal_califications.size

		if total == 0
			resp = 0.0
		else
			resp = ((calificados.to_f / total.to_f) * 100).round(2)
		end

		return resp
	end
	# -------

	 # ES: Se declaran privados, porque estan replicados en el priorizationHelper!
	 # EN: Declared as private, because are replicated in the helper: PrioritizationHelper!
	 private :getPorcentajeRiesgos, :getPorcentajeObjetivos 


  end # --- module SharedHelper
end # --- module Escenarios