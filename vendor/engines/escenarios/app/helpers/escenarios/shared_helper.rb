#encoding: utf-8
module Escenarios
  module SharedHelper
  	# SLA: Helper que puede ser utilizado desde la aplicacion principal.

    # Helper para listar y formatear los escenarios de evaluacion de riesgos
  	def escenariosListRiskEscenarios(empId)
  		content = []
  		risks = RiskEscenario.where(enterprise_id: empId)
	    # Inserta un registro de separacion:
	    content.push('Escenarios de evaluación de riesgos$:$' << risks.size.to_s)

	    risks.each do |risk|
	      # String: ID_RISK|name
	      string = risk.id.to_s << '_RISK|' << risk.name
	      content.push(string)
	    end

	    content
  	end
  	# ---------

  	# Helper para listar y formatear los escenarios de evaluacion de objetivos
  	def escenariosListGoalEscenarios(empId)
  		content = []
  		goals = GoalEscenario.where(enterprise_id: empId)
	    # Inserta un registro de separacion:
	    content.push('Escenarios de evaluación de objetivos$:$' << goals.size.to_s)

	    goals.each do |goal|
	      # String: ID_GOAL|name
	      string = goal.id.to_s << '_GOAL|' << goal.name
	      content.push(string)
	    end

	    content
  	end
  	# ---------

  	# Helper para listar y formatear los escenarios de priorizacion
  	def escenariosListPriorEscenarios(empId)
  		content = []
  		priors = PriorizationEscenario.where(enterprise_id: empId)
	    # Inserta un registro de separacion:
	    content.push('Escenarios de priorización$:$' << priors.size.to_s)

	    priors.each do |prior|

	      escTemp = priors.select{|e| (e.risk_escenario.id == prior.risk_escenario.id) && (e.goal_escenario.id == prior.goal_escenario.id)}
	      priors = priors - escTemp

	      escTemp.each_with_index do |e, index|
	        if index > 0
	          # Se debe identar
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

  	# Helper que genera todo el contenido HTML de los escenarios de evaluacion de riesgos:
  	def escenariosGenerateRisksHTML(empresa, riskIds, log)
  		escenarios = RiskEscenario.where(id: riskIds)
  		# Directorio actual: (El de la empresa)
	  	actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	  	Dir.chdir(actualFolder)
	  	rootEmpresa = actualFolder

	  	# Crea la carpeta para los escenarios de riesgo y su respectivo archivo index:
	  	folderName = 'riskEscenarios'
	  	FileUtils.mkdir_p(folderName)
	  	log.push("Directorio creado: riskEscenarios (Para los escenarios de evaluación de riesgos)")

	    # CRea el archivo de estilos para los mapas de decision:
	    Dir.chdir(rootEmpresa+"/css")
	    riskStyles = 'riskStyles.css'
	    fileHtml = File.new(riskStyles, "w")
	    lineHtml = 'td.riskmap{  border: 1px solid white;  width:40px;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'span#showRiskScaleHTML{cursor:pointer;margin-left:15px;font-size:15px;color:#428bca;}'
	    fileHtml.puts lineHtml

	    fileHtml.close()
	    log.push("Archivo creado: riskStyles.css (Archivo de estilos particular para los escenarios de riesgo)")

	    # Crea el archivo de js para el dialogo en los escenarios de riesgo:
	    Dir.chdir(rootEmpresa+"/js")
	    riskJs = Rails.root.to_s << '/app/assets/javascripts/riskJS.js'
	    FileUtils.cp riskJs, 'riskJS.js'

	  	Dir.chdir(actualFolder+"/"+folderName) # Ingresa a la carpeta riskEscenarios
	  	# Crea el archivo index para los escenarios de evaluacion de riesgos:
	  	fileHtml = File.new("indexRiskEscenarios.html", "w")
	  	lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" type="text/css" href="../css/styles.css"/></head>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<body><div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<li class="active">['<< empresa.name << '] Gobierno de TI - Escenarios de Evaluación de Riesgos</li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '</ol></div>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<h2>Escenarios de Evaluación de Riesgos:</h2>'
	  	fileHtml.puts lineHtml
	  	if escenarios.size == 0
	  		lineHtml = '<div class="alert alert-info">'
	  		fileHtml.puts lineHtml
	  		lineHtml = 'No hay escenarios de evaluación de riesgos en el sistema, para la empresa: '<< empresa.name << '.' << '</div>'
	  		fileHtml.puts lineHtml
	  	else
	  		escenarios.each do |e|
	        strName = e.governance_structure
	        if strName.nil?
	          strName = 'Escenario generado por el sistema'
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
	  	log.push("Archivo creado: riskEscenarios.html (Índice de los escenarios de evaluación de riesgos)")


	    # Crea el archivo de cada escenario de riesgos:
	    risksGen = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
	    hijosGen = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, empresa.id)
	    riskmap = empresa.configuracion
	    categories = RiskCategory.where("id_padre IS NULL")
	    # Si no encuentra la configuración, la envía vacía:
	  	if riskmap.nil?
		    # Envía en los niveles, los valores por defecto
		    default = RISK_SCALE   
		    niveles = default.split('|')
	  	else
		    if riskmap.riskmap.nil? or riskmap.riskmap.empty?
		      # Envía en los niveles, los valores por defecto
		      default = RISK_SCALE   
		      niveles = default.split('|')
		    else
		      niveles = riskmap.riskmap.split('|')
		    end
		end

		# Genera el archivo de cada escenario de evaluacion de riesgos:
		escenarios.each do |esc|
			# Calificaciones:
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
	  		lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<li class="active">[' << empresa.name << '] Evaluación de Riesgos: ' << esc.name << '</li></ol></div>'
	  		fileHtml.puts lineHtml
	  		lineHtml = '<h2>Escenario: ' << esc.name << '<span id="showRiskScaleHTML" title="Ver escala de evaluación de riesgos">Ver escala de evaluación de riesgos</span></h2>'
	  		fileHtml.puts lineHtml

	  		categories.each do |cat|
	  			lineHtml = '<div class="alert alert-info"><span style="font-size:18px;">Categoría de Riesgo: ' << cat.description << '</span></div>'
				fileHtml.puts lineHtml

				myRisks = risksGen.select{|r| r.risk_category.id_padre == cat.id}

				myRisks.each do |risk|
					lineHtml = '<div style="width:100%;height:40px;margin-top:10px;" >'
					fileHtml.puts lineHtml
					calGen = cals.select { |cal|  cal.risk == risk  }.first
					lineHtml = '<div style="float:left;width:3%;"><span style="width:35px;height:25px;margin-right:5px;'
					fileHtml.puts lineHtml
					lineHtml = 'border:solid 2px #4A8AFA;display:inline-block;" title="Calificación promedio de sus riesgos específicos">'
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

					# Renderiza los hijos también:
					hijos = hijosGen.select{|h| h.riesgo_padre_id == risk.id}

					if hijos.size > 0

						hijos.each do |h|
							# Revisa si tiene calificacion ese riesgo:
							myCal = cals.select {|cal| cal.risk == h }.first
							if myCal.nil?
								# No calificado
								lineHtml = '<p style="margin-left:4%;color:#333;"><span style="width:35px;height:20px;margin-right:5px;'
								fileHtml.puts lineHtml
								lineHtml = 'border:solid 1px #333;display:inline-block;">&nbsp;-</span>'
								fileHtml.puts lineHtml
								lineHtml = '<i>- ' << h.descripcion << '</i></p>'
								fileHtml.puts lineHtml
							else
								# Calificado
								cont = 0
					            niveles.each do |nivel|
					              cont+= 1
					              if nivel.to_i == myCal.valor.to_i
					                break
					              end
					            end

					            color = 'yellow'
					            importancia = 'Media/Tolerable'
					            
					            if cont == 19 || cont == 25 || cont == 26 || cont == 31 || cont == 32 || cont == 33 
					                # VERDE:  
					               color = 'green'
					               importancia = 'Baja/Aceptable'
					            elsif cont == 4 || cont == 5 || cont == 6 || cont == 11 || cont == 12 || cont == 18 
					              # ROJO
					              color = 'red'
					              importancia = 'Muy Alta/Inadmisible'
					            elsif cont == 2 || cont == 3 || cont == 9 || cont == 10 || cont == 16 || cont == 17 || cont == 23 || cont == 24 || cont == 30
					               # NARANJA 
					               color = 'orange'
					               importancia = 'Alta/Inaceptable'
					            end

					            if myCal.risk_type.nil?
					            	r_t = 'No definido'
					            else
					            	r_t = myCal.risk_type
					            end

					            if myCal.evidence.nil? || myCal.evidence.blank?
					            	evi = 'No definida'
					            else
					            	evi = myCal.evidence
					            end

					            lineHtml = '<p style="margin-left:4%;color:#333;"><span style="background-color:' << color << ';width:35px;'
					            fileHtml.puts lineHtml
					            lineHtml = 'height:20px;margin-right:5px;border:solid 1px #333;display:inline-block;color:black;" >&nbsp;&nbsp;' << myCal.valor.to_s
					            fileHtml.puts lineHtml
					            lineHtml = '</span><i>- ' << h.descripcion << '</i><br><span style="font-size:12px;color:#AAA;">'
					            fileHtml.puts lineHtml
					            lineHtml = '<i>Impacto financiero: ' << myCal.cantidad.to_s << ' (USD), Tipo de Riesgo: ' << r_t << ',' 
					            fileHtml.puts lineHtml
					            lineHtml = 'Importancia/Tolerancia: ' << importancia << ', Evidencia: ' << evi << '</i></span></p>'
					            fileHtml.puts lineHtml 						
							end # Cierra calificado

						end # Cierra hijos

					end # Cierra hijos.size > 0
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

		    lineHtml = '<div id="dialogRiskScale" title="Escala de evaluación de riesgos"><div style="width:100%;"><div style="float:left;width:130px;">'
		    fileHtml.puts lineHtml
		    lineHtml = '<img src="../images/y-axis.png" style="margin-top:35px;"></div><div style="float:left;width:240px;">'
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

		    lineHtml = '</tr></table></div><div style="float:left;width:220px;"><img src="../images/imp_tol.png" style="margin:17px 0 10px 55px">'
		    fileHtml.puts lineHtml
		    lineHtml = '<img align="left" src="../images/money.png" style="width:30px;height:30px;margin: 10px 5px 0 70px;">'
		    fileHtml.puts lineHtml
		    lineHtml = '<p style="font-size:11px;width:70%;margin-left:45%;">Impacto financiero (aproximado) por unidad de riesgo (en USD):</p></img>'
		    fileHtml.puts lineHtml
		    lineHtml = '<input type="number" style="margin:8px 0 10px 70px;width:150px;" min="0" disabled value="' << niveles[36] << '"></div>'
		    fileHtml.puts lineHtml
		    lineHtml = '</div><div style="width:100%;"><img src="../images/x-axis.png" style="margin:9px 0 0 130px;"></div></div>'
		    fileHtml.puts lineHtml

			lineHtml = '</body></html>'
		    fileHtml.puts lineHtml
		    fileHtml.close()

		end 
		# ----- escenarios.each do

		# Devuelve el arreglo del log actualizado
		log
  	end
  	# --------- escenariosGenerateRisksHTML


  	# Helper para generar el contenido HTML de los escenarios de evaluacion de objetivos:
  	def escenariosGenerateGoalsHTML(empresa, goalIds, log)
  		escenarios = GoalEscenario.where(id: goalIds)
  		# Directorio actual: (El de la empresa)
	    actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	    Dir.chdir(actualFolder)
	    rootEmpresa = actualFolder

	    # Crea el archivo de js para la interaccion con pestañas:
	    Dir.chdir(rootEmpresa+"/js")
	    goalJs = Rails.root.to_s << '/app/assets/javascripts/goalJS.js'
	    FileUtils.cp goalJs, 'goalJS.js'

	    Dir.chdir(rootEmpresa)

	    # Crea la carpeta para los escenarios de objetivos:
	    folderName = 'goalEscenarios'
	    FileUtils.mkdir_p(folderName)
	    log.push("Directorio creado: goalEscenarios (Para los escenarios de evaluación de objetivos)")
	    Dir.chdir(actualFolder+"/"+folderName) # Ingresa a la carpeta goalEscenarios


	    # Crea el archivo de cada escenario de evaluacion de objetivos:
	    # Variables comunes a todos los escenarios:

	    # Objetivos de Negocio:
	    bGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL)
	    # Objetivos de TI:
	    itGoals = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL)
	    # Dimensiones:
	    it_dims = itGoals.map { |goal| goal.dimension }.uniq
	    b_dims = bGoals.map { |goal| goal.dimension }.uniq
	    # Especificos:
	    especificos = Goal.where("goal_type = ? AND enterprise_id = ?", SPECIFIC_TYPE, empresa.id)

	    # Genera el archivo de cada escenario de evaluacion de objetivos
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
			lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
			fileHtml.puts lineHtml
			lineHtml = '<li class="active">[' << empresa.name << '] Evaluación de Objetivos: ' << esc.name << '</li></ol></div>'
			fileHtml.puts lineHtml
			lineHtml = '<h2>Escenario: ' << esc.name << '</h2>'
			fileHtml.puts lineHtml
			lineHtml = '<ul class="nav nav-pills"><li class="active" id="pill_b_generated"><a>Objetivos de Negocio</a></li>'
			fileHtml.puts lineHtml
			lineHtml = '<li id="pill_it_generated" style="cursor:pointer;"><a>Objetivos de TI</a></li></ul>'
			fileHtml.puts lineHtml
			lineHtml = '<div id="business_goals" style="border:solid 1px #DDD;min-height:500px;padding:10px;overflow:auto;">'
			fileHtml.puts lineHtml

			# Recorre las dimensiones de negocio:
			b_dims.each do |dim|

				lineHtml = '<div class="alert alert-info"><span style="text-align:center;font-size:18px;">'
				fileHtml.puts lineHtml
				lineHtml = 'Dimensión: ' << dim << '</span></div>'
				fileHtml.puts lineHtml

				temp_goals = bGoals.select { |goal|  goal.dimension == dim  }
				if temp_goals.size == 0
				  lineHtml = '<p>No existen objetivos de negocio bajo esta dimensión.</p>'
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
				      lineHtml = '<label>Calificación actual: </label> Importancia: '
				      fileHtml.puts lineHtml
				      
				      if myCal.importance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.importance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = ', Desempeño: '
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

				    # Renderiza sus hijos:
				    hijos = especificos.select{|esp| esp.parent_id == goal.id}
				    hijos.each do |hijo|
				      lineHtml = '<p style="margin-left:1%;color:#AAA;"><i>- ' << hijo.description << '</i>'
				      fileHtml.puts lineHtml
				    end

				    lineHtml = '</div>'
				    fileHtml.puts lineHtml

				  end # Objetivos bajo esa dimension
				end # tiene objetivos bajo esta dimension?
			end # Dimensiones de negocio

			lineHtml = '</div>'
			fileHtml.puts lineHtml 

			lineHtml = '<div id="it_goals" style="display:none;border:solid 1px #DDD;min-height:500px;padding:10px;overflow:auto;">'
			fileHtml.puts lineHtml

			# Agrupa por dimension:
			it_dims.each do |dim|
				lineHtml = '<div class="alert alert-info"><span style="text-align:center;font-size:18px;">'
				fileHtml.puts lineHtml 
				lineHtml = 'Dimensión: ' << dim << '</span></div>'
				fileHtml.puts lineHtml 

				temp_goals = itGoals.select { |goal|  goal.dimension == dim  }

				if temp_goals.size == 0
				  lineHtml = '<p>No existen objetivos de TI bajo esta dimensión.</p>'
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
				      lineHtml = '<label>Calificación actual: </label> Importancia: '
				      fileHtml.puts lineHtml
				      
				      if myCal.importance == 0
				        lineHtml = ' N/A '
				        fileHtml.puts lineHtml
				      else
				        lineHtml = myCal.importance
				        fileHtml.puts lineHtml
				      end

				      lineHtml = ', Desempeño: '
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

				    # Renderiza sus hijos:
				    hijos = especificos.select{|esp| esp.parent_id == goal.id}
				    hijos.each do |hijo|
				      lineHtml = '<p style="margin-left:1%;color:#AAA;"><i>- ' << hijo.description << '</i>'
				      fileHtml.puts lineHtml
				    end

				    lineHtml = '</div>'
				    fileHtml.puts lineHtml
				    
				  end # Objetivos
				end # Objetivos de TI bajo esta dimension?
			end # Dimensiones de TI

			lineHtml = '</div>'
			fileHtml.puts lineHtml

			lineHtml = '</body></html>'
			fileHtml.puts lineHtml
			fileHtml.close()
	    end
	    # ---- escenarios.each do

	    # Devuelve el log actualizado
	    return log

  	end
  	# ------ escenariosGenerateGoalsHTML

  	# Helper que genera el contenido HTML de los escenarios de priorizacion:
  	def escenariosGeneratePriorsHTML(empresa, priorIds, log)
  		escenarios = PriorizationEscenario.where(id: priorIds)
  		# Directorio actual: (El de la empresa)
	  	actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	  	Dir.chdir(actualFolder)
	  	rootEmpresa = actualFolder

	  	# Crea la carpeta para los escenarios de priorización y su respectivo archivo index:
	  	folderName = 'priorizationEscenarios'
	  	FileUtils.mkdir_p(folderName)
	  	log.push("Directorio creado: prioriozationEscenarios (Para los escenarios de priorización)")
	  	Dir.chdir(actualFolder+"/"+folderName) # Ingresa a la carpeta priorizationEscenarios
	  	# Crea el archivo index para los escenarios de priorizacion:
	  	fileHtml = File.new("indexPriorizationEscenarios.html", "w")
	  	lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
	  	fileHtml.puts lineHtml
	    lineHtml = '<link rel="stylesheet" type="text/css" href="../css/priorizationStyles.css"/></head>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<body><div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<li class="active">['<< empresa.name << '] Gobierno de TI - Escenarios de Priorización</li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '</ol></div>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<h2>Escenarios de Priorización:</h2>'
	  	fileHtml.puts lineHtml

	  	if escenarios.size == 0
	  		lineHtml = '<div class="alert alert-info">'
	  		fileHtml.puts lineHtml
	  		lineHtml = 'No hay escenarios de priorización en el sistema, para la empresa: '<< empresa.name << '.' << '</div>'
	  		fileHtml.puts lineHtml
	  	else
			escenarios.each do |e|
				porcRiesgos = getPorcentajeRiesgos(e.risk_escenario)
			  	porcObjs = getPorcentajeObjetivos(e.goal_escenario)
				lineHtml = '<p><span>Escenario: <a href="escP' << e.id.to_s << '.html">' << e.name << '</a></span><br>'
				fileHtml.puts lineHtml
				lineHtml = '<span class="info"><i>[Completado: ' << porcRiesgos.to_s << ' %] Escenario de evaluación de riesgos: ' << e.risk_escenario.name << ', Peso Riesgos: ' << e.risksWeight.to_s << '</i></span><br>'
				fileHtml.puts lineHtml
				lineHtml = '<span class="info"><i>[Completado: ' << porcObjs.to_s << ' %] Escenario de evaluación de objetivos: ' << e.goal_escenario.name << ', Peso Objetivos: ' << e.goalsWeight.to_s << '</i></span><br></p>' 
	            fileHtml.puts lineHtml
			end
		end
		# --- escenarios.size == 0

		lineHtml = '</body></html>'
	    fileHtml.puts lineHtml

		fileHtml.close()
		log.push("Archivo creado: indexPriorizationEscenarios.html (Índice de los escenarios de priorización)")

		# CRea el archivo de estilos para los mapas de decision:
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
		log.push("Archivo creado: priorizationStyles.css (Archivo de estilos particular para los escenarios de priorización)")

		Dir.chdir(actualFolder+"/"+folderName) # Ingresa a la carpeta priorizationEscenarios

		# Crea el archivo de la priorizacion de cada escenario:
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
			lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
			fileHtml.puts lineHtml
			#lineHtml = '<li><a href="indexPriorizationEscenarios.html">Escenarios de priorización</a></li>'
			#fileHtml.puts lineHtml
			lineHtml = '<li class="active">[' << empresa.name << '] Priorización: ' << esc.name << '</li></ol></div>'
			fileHtml.puts lineHtml
			lineHtml = '<h2>Escenario: ' << esc.name << '    [ ' << esc.fecha_ejecucion.to_s << ' ]' << '</h2>'
			fileHtml.puts lineHtml
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

		    # Imprime la tabla:
			lineHtml = '<table style="font-size:13px;"><tr><th>ID Proceso</th><th>Descripción</th>'
			fileHtml.puts lineHtml
			escalaRisk = ( ( esc.risksWeight / 100.0 ) * 5.0).round(2).to_s
			escalaGoal = ( ( esc.goalsWeight / 100.0 ) * 5.0).round(2).to_s

			lineHtml = '<th>Importancia de Riesgos <br> (' << stats[1] << '%)<br><span style="font-size:10px;color:blue;font-style:italic;">[ Escala: 0 - ' <<  escalaRisk << ' ]</span></th>'
			fileHtml.puts lineHtml
			lineHtml = '<th>Importancia Objetivos de TI <br> (' << stats[2] << '%)<br><span style="font-size:10px;color:blue;font-style:italic;">[ Escala: 0 - ' <<  escalaGoal << ' ]</span></th>'
			fileHtml.puts lineHtml
			lineHtml = '<th>Importancia General<br><span style="font-size:10px;color:blue;font-style:italic;">[ Escala: 0 - 5 ]</span></th><th>Orden</th></tr>'
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

		# Devuelve el log actualizado:
		log
  	end
  	# ----- escenariosGeneratePriorsHTML

  	# Metodo que calcula el porcentaje de completitud de un escenario de riesgos
	def getPorcentajeRiesgos(riskEscenario)
		#totalGenericos = Risk.where("nivel = ?", 'GENERICO').size
		totalHijos = Risk.where("nivel = ? AND enterprise_id = ?", SPECIFIC_TYPE, riskEscenario.enterprise.id).map{|h| h.id}
		total = totalHijos.size # + totalGenericos
		#calificados = riskEscenario.califications.size
		calificados = RiskCalification.where(risk_escenario_id: riskEscenario.id, risk_id: totalHijos).size

		if total == 0
			resp = 0.0
		else
			resp = ((calificados.to_f / total.to_f) * 100).round(2)
		end

		return resp
	end
	# ------

	# Metodo que calcula el porcentaje de completitud de un escenario de objetivos
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

	 private :getPorcentajeRiesgos, :getPorcentajeObjetivos # Se declaran privados, porque estan replicados en el priorizationHelper!





  end # --- module SharedHelper
end # --- module Escenarios