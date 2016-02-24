#encoding: utf-8

module Mapas
  module SharedHelper
  	
  	# ES: Helper que puede ser utilizado desde la aplicacion principal.
  	# EN: Helper that can be used from the main application.


  	# ES: Helper para listar y formatear cada uno de los mapas de decision de una empresa
  	# EN: Helper to list and format each of the decision maps of an enterprise
  	def mapasListDecisionMaps(empId)
  		content = []
  		# ES: Mapas de decision:
  		# EN: Decision Maps
	    mapas = DecisionMap.where(enterprise_id: empId)

	    # ES: Inserta un registro de separacion:
	    # EN: Insert a separator:
	    content.push('Decision Maps$:$' << mapas.size.to_s)

	    mapas.each do |mapa|
	      # String: ID_MAP|name
	      # ES: Si el mapa es de tipo delegacion de responsabilidades, lo identifica:
	      # EN: If the map's type is responsibilities delegation, identify it:
	      if mapa.map_type == MAP_TYPE_2
	        string = mapa.id.to_s << '_MAPD|' << mapa.name
	      else
	        string = mapa.id.to_s << '_MAP|' << mapa.name
	      end
	      
	      content.push(string)
	    end

	    content
  	end
  	# ---------- mapasListDecisionMaps

  	# ES: Helper que genera el archivo HTML de cada mapa de decision:
  	# EN: Helper to generate the HTML file of each decision map:
  	def mapasGenerateMapsHTML(empresa, mapIds, archIds, log)
	    mapas = DecisionMap.where(id: mapIds)

	  	log.push("Creating decision maps content...")


	  	# ES: Directorio actual: (El de la empresa)
	  	# EN: Current directoy: (of the enterprise)
	  	actualFolder = Rails.root.to_s << "/HTML_CONTENT/" << '[' << empresa.id.to_s << '] ' << empresa.name
	  	Dir.chdir(actualFolder)
	  	rootEmpresa = actualFolder

	  	# ES: Crea la carpeta para los mapas de decision y su respectivo archivo index:
	  	# EN: Create the directory for the decision maps and its respective index file:
	  	folderName = 'decisionMaps'
	  	FileUtils.mkdir_p(folderName)
	  	log.push("Directory created: decisionMaps (Decision Maps)")
	  	Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta DecisionMaps - EN: Enters to the directory DecisionMaps
	  	# ES: Crea el archivo index para los mapas de decision:
	  	# EN: Create the index file for the decision maps:
	    fileHtml = File.new("indexMaps.html", "w")
	    lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	      <link rel="stylesheet" type="text/css" href="../css/styles.css"/></head>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<body><div><ol class="breadcrumb"><li><a href="../index.html">Home</a></li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<li class="active">['<< empresa.name << '] IT Governance - Decision Maps</li>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '</ol></div>'
	  	fileHtml.puts lineHtml
	  	lineHtml = '<h2>Decision Maps</h2>'
	  	fileHtml.puts lineHtml
	  	if mapas.size == 0
	  		lineHtml = '<div class="alert alert-info">'
	  		fileHtml.puts lineHtml
	  		lineHtml = 'No decision maps in the system, for the enterprise: '<< empresa.name << '.' << '</div>'
	  		fileHtml.puts lineHtml
	  	else
	  		mapas.each do |m|
	  			lineHtml = '<a href="map' << m.id.to_s << '.html"> [' << m.governance_structure.name << ': ' << m.name << '] - ' << m.description << '</a><br>'
	  	    fileHtml.puts lineHtml
	  		end
	  	end

	  	lineHtml = '</body></html>'
	    fileHtml.puts lineHtml

	  	fileHtml.close()
	  	log.push("File created: indexMaps.html")

	  	# ES: Crea el archivo de estilos para los mapas de decision:
	  	# EN: Create the css file for the decision maps:
	  	Dir.chdir(rootEmpresa+"/css")
	  	mapStyles = 'mapStyles.css'
	  	fileHtml = File.new(mapStyles, "w")
	  	lineHtml = 'tr, th, td {padding: 10px;	border: solid 1px #cacaca;}'
	  	fileHtml.puts lineHtml
	  	lineHtml = 'th {color: #333;font-weight: normal;background-color: #f5f5f5;}'
	  	fileHtml.puts lineHtml
	  	lineHtml = 'p.showFuncs {font-size: 12px;margin: 0px;color: #3c763d;font-weight: bold; font-style: italic; cursor: pointer;}'
	  	fileHtml.puts lineHtml
	    lineHtml = 'p.cell {font-size: 12px;margin: 0px;color: #3c763d;font-weight: bold; font-style: italic;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch, table#arch td {border: solid 1px #949494; padding: 5px;  text-align: center;  font-size: 12px;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch td.rotate{-webkit-transform: rotate(270deg);-moz-transform: rotate(270deg);-o-transform:rotate(270deg); writing-mode: lr-tb;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch td.blank{  border: none;  padding: 0px;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch tr.blank{  border: none;  padding: 0px;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch td.maxRed{  border: solid 2px #FF4444;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'table#arch td.maxOrange{  border: solid 2px #FAAB19;}'
	    fileHtml.puts lineHtml
	    lineHtml = 'span.totalDBD {color: blue;font-size: 12px;}'
	    fileHtml.puts lineHtml

	    fileHtml.close()
	  	log.push("File created: mapStyles.css")

	    # ES: Crea el archivo de js para el dialogo en los mapas:
	    # EN: Create the js file for the dialog in the decision maps:
	    Dir.chdir(rootEmpresa+"/js")
	    mapJs = Rails.root.to_s << '/app/assets/javascripts/mapJS.js'
	    FileUtils.cp mapJs, 'mapJS.js'

	  	Dir.chdir(actualFolder+"/"+folderName) # ES: Ingresa a la carpeta DecisionMaps - EN: Enter the directory DecisionMaps

	    # ES: Crea el archivo de cada mapa de decisión:
	    # EN: Create the file of each decision map:
	    archs = DecisionArchetype.all
	    genericas = GovernanceDecision.where("decision_type = ? AND enterprise_id = ?", GENERIC_TYPE, empresa.id).order(dimension: :asc)
	    resps = [DELEG_RESP_1,DELEG_RESP_2,DELEG_RESP_3,DELEG_RESP_4,DELEG_RESP_5]

	    mapas.each do |m|
	    	nameFile = 'map' << m.id.to_s << '.html'
			fileHtml = File.new(nameFile, "w")
			lineHtml = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/styles.css"/>'
			fileHtml.puts lineHtml
			lineHtml = '<link rel="stylesheet" type="text/css" href="../css/mapStyles.css"/>'
			fileHtml.puts lineHtml	
		    lineHtml = '<link rel="stylesheet" href="../css/my_jquery.css" />'
		    fileHtml.puts lineHtml  
			lineHtml = '<script src="http://code.jquery.com/jquery-1.10.2.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="http://code.jquery.com/ui/1.11.0/jquery-ui.js"></script>'
			fileHtml.puts lineHtml
			lineHtml = '<script src="../js/mapJS.js"></script>'
			fileHtml.puts lineHtml

			if m.map_type == MAP_TYPE_1 
				# ES: Arquetipos
				# EN: Archetypes
			  	details = m.map_details
				# ES: Define estilos individuales
				# EN: Define individual styles
				lineHtml = '</head><body>'
				fileHtml.puts lineHtml
				lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
				fileHtml.puts lineHtml
				lineHtml = '<li class="active">[' << empresa.name << '] Decision Map - ' << m.name << '</li></ol></div>'
				fileHtml.puts lineHtml
				lineHtml = '<h2>Decision Map: ' << m.name << ' </h2>'
				fileHtml.puts lineHtml
				lineHtml = '<div><table style="font-size:14px;"><tr><th>Decisión</th>'
				fileHtml.puts lineHtml
				archs.each do |a|
					lineHtml = '<th>' << a.name << '<br> ' << a.description << '</th>'
					fileHtml.puts lineHtml
				end
				lineHtml = '</tr>'
				fileHtml.puts lineHtml
					
				divs = archs.size
		        dim_ant = nil 
		        cols = divs + 1

				genericas.each do |gen|
					if dim_ant != gen.dimension
						lineHtml = '<tr style="background-color:#d9edf7;border-color:#bce8f1;">'
						fileHtml.puts lineHtml
						lineHtml = '<td colspan = ' << cols.to_s << ' style="text-align:center;color:#31708f;font-size:18px;">'
						fileHtml.puts lineHtml
						lineHtml = 'Dimension: ' << gen.dimension << '</td></tr>'
						fileHtml.puts lineHtml
						dim_ant = gen.dimension
					end

					renderTableDec(fileHtml, gen, divs, 0, details)            	
				end

				lineHtml = '</table></div>'
				fileHtml.puts lineHtml


			else
				# ES: Delegacion de responsabilidades
				# EN: Responsibilities delegation
				details = m.map_details
				findings = m.findings
				risks = Risk.where("nivel = ?", 'GENERICO').order(id: :asc)
				categories = RiskCategory.where("id_padre IS NULL")
					
				# ES: Define estilos individuales:
				# EN: Define individual styles:
				lineHtml = '</head><body>'
			  	fileHtml.puts lineHtml
				lineHtml = '<div><ol class="breadcrumb"><li><a href="../index.html">Inicio</a></li>'
				fileHtml.puts lineHtml
				lineHtml = '<li class="active">[' << empresa.name << '] Decision Map - ' << m.name << '</li></ol></div>'
				fileHtml.puts lineHtml
				lineHtml = '<h2>Decision Map: ' << m.name << ' <span style="color:#428bca;cursor:pointer;margin:0 0 0 7px;font-size:15px;" id="archReport">'
				fileHtml.puts lineHtml
				# ES: Si tiene activo el reporte de identificacion, activa el link desde alli:
				# EN: If the identification report is activated, enable the link from here:
				if archIds.include?(m.id.to_s)
				lineHtml = 'Show identified archetype'
				fileHtml.puts lineHtml
				end

				lineHtml = '</span></h2><div><table style="font-size:14px;"><tr><th style="width:30%;">Decision</th>'
				fileHtml.puts lineHtml 

				resps.each do |r|
					lineHtml = '<th>' << r << '<br></th>'
					fileHtml.puts lineHtml
				end

				divs = resps.size
				dim_ant = nil 
				cols = divs + 1

				genericas.each do |gen|
					if dim_ant != gen.dimension
						lineHtml = '<tr style="background-color:#d9edf7;border-color:#bce8f1;">'
					    fileHtml.puts lineHtml
						lineHtml = '<td colspan = ' << cols.to_s << ' style="text-align:center;color:#31708f;font-size:18px;">'
						fileHtml.puts lineHtml
						lineHtml = 'Dimension: ' << gen.dimension << '</td></tr>'
						fileHtml.puts lineHtml
						dim_ant = gen.dimension
					end

					renderTableDec2(fileHtml, gen, divs, 0, details, m)
				end

				lineHtml = '</table></div>'
				fileHtml.puts lineHtml

				# ES: Construye el dialogo del reporte de arquetipos:
				# EN: Build the dialog of the archetypes report:
				if archIds.include?(m.id.to_s)

					dimensions = [DIM_DEC_1, DIM_DEC_2, DIM_DEC_3, DIM_DEC_4, DIM_DEC_5]
					arquetipos = DecisionArchetype.all

					lineHtml = '<div id="dialogArchReport" style="font-size:12px;">'
					fileHtml.puts lineHtml
					lineHtml = '<div><table id="arch"><tr class="blank"><td colspan="2" class="blank"></td><td colspan="10">Decision Domain</td></tr><tr class="blank">'
					fileHtml.puts lineHtml
					lineHtml = '<td colspan="2" class="blank"></td>'
					fileHtml.puts lineHtml

					dimensions.each do |dim|
					  stat = GovernanceDecision.where("enterprise_id = ? AND dimension = ?", empresa.id, dim).size
					  lineHtml = '<td colspan="2">' << dim << '<br><span class="totalDBD">' << stat.to_s << ' decisions</span></td>'
					  fileHtml.puts lineHtml
					end

					lineHtml = '</tr><tr class="blank"><td colspan="2" class="blank"></td><td>Decides</td><td>Consulted</td><td>Decides</td><td>Consulted</td>'
					fileHtml.puts lineHtml
					lineHtml = '<td>Decides</td><td>Consulted</td><td>Decides</td><td>Consulted</td><td>Decides</td><td>Consulted</td></tr>'
					fileHtml.puts lineHtml
					lineHtml = '<tr><td rowspan="7" class="rotate">Governance Archetype</td>'
					fileHtml.puts lineHtml
					lineHtml = '<td>' << arquetipos[0].name << '</td>'
					fileHtml.puts lineHtml
					contArchs = 1

					content = identify_archetype_method([m.id])

					content.each_with_index do |valor, i|
					  modulo = 1

					  if i > 0
					    modulo = i % 10
					  end

					  if ((modulo == 0) && (contArchs <= arquetipos.size))

					    if contArchs == arquetipos.size
					      lineHtml = '</tr><tr><td>No-Responsible</td>'
					    else
					      lineHtml = '</tr><tr><td>' << arquetipos[contArchs].name << '</td>'
					    end            
					    fileHtml.puts lineHtml
					    contArchs+=1
					  end

					  lineHtml = '<td'
					  fileHtml.puts lineHtml

					  if valor[0].eql?('M')

					    if valor[1].eql?('R')
					      # ES: Lo marca en rojo:
					      # EN: Mark it with red:
					      lineHtml = ' class="maxRed" >'
					      fileHtml.puts lineHtml
					      valor = valor.gsub("MR","").strip
					    else
					      # ES: Lo marca en naranja:
					      # EN: Mark it with orange:
					      lineHtml = ' class="maxOrange">'
					      fileHtml.puts lineHtml
					      valor = valor.gsub("MN","").strip
					    end

					  else
					    lineHtml = '>'
					    fileHtml.puts lineHtml
					  end

					  if !valor.eql?("-") 
					    lineHtml = valor.strip << '%'
					  else
					    lineHtml = valor.strip
					  end

					  fileHtml.puts lineHtml

					  lineHtml = '</td>'
					  fileHtml.puts lineHtml
					end # content.each do

					lineHtml = '</table></div>'
					fileHtml.puts lineHtml

					# ES: INCLUIR ESTILOS DE LA TABLA!!!
					# EN: INCLUDE TABLE STYLES!!!

					lineHtml = '</div>'
					fileHtml.puts lineHtml

				end # archs.include?()


				# ES: Construye los divs del dialogo de hallazgos:
				# EN: Build the divs in the findings dialog:
				lineHtml = '<div id="dialog_findings" style="font-family:"Segoe UI Light","Helvetica Neue","Segoe UI","Segoe WP",sans-serif;">'
				fileHtml.puts lineHtml

				findings.each do |find|

					parsedRisks = find.parsed_risks

					if parsedRisks.nil?
					  parsedRisks = []
					else
					  parsedRisks = parsedRisks.split("|")
					end

					lineHtml = '<div id="infoFinding' << find.governance_decision_id.to_s << '" style="display:none;">'
					fileHtml.puts lineHtml

					decTemp = GovernanceDecision.find(find.governance_decision_id) # PERFORMANCE_ALERT!

					lineHtml = '<h4 style="font-size:15px;">Decision:</h4>'
					fileHtml.puts lineHtml
					lineHtml = '<p style="font-style:italic;color:#AAA;font-size:13px;font-family: Helvetica,Arial,sans-serif">' << decTemp.description << '</p>'
					fileHtml.puts lineHtml

					lineHtml = '<h4 style="font-size:15px;">Finding Description:</h4>'
					fileHtml.puts lineHtml
					# ES: Descripcion del hallazgo:
					# EN: Finding's description:
					lineHtml = '<p'
					fileHtml.puts lineHtml 
					lineHtml = 'style="font-style:italic;color:#AAA;font-size:12px;">' << find.description << '</p>'
					fileHtml.puts lineHtml

					lineHtml = '<h4 style="font-size:15px;" >Proposed Changes:</h4>'
					fileHtml.puts lineHtml
					# ES: Cambios propuestos:
					# EN: Proposed updates:
					lineHtml = '<p'
					fileHtml.puts lineHtml
					updates = find.proposed_updates

					if updates.nil?
					  updates = 'Undefined'          
					end
					lineHtml = 'style="font-style:italic;color:#AAA;font-size:12px;">' << updates << '</p>'
					fileHtml.puts lineHtml

					lineHtml = '<h4 style="font-size:15px;" >Related risks from the finding:</h4>'
					fileHtml.puts lineHtml
					# ES: Riesgos asociados:
					# EN: Related risks:
					lineHtml = '<div>'
					fileHtml.puts lineHtml

					categories.each do |cat|
					  lineHtml = '<div class="alert alert-info" style="padding:9px;margin-bottom:0px;">'
					  fileHtml.puts lineHtml
					  lineHtml = '<span style="font-size:13px;">Risk category: ' << cat.description << '</span></div>' 
					  fileHtml.puts lineHtml

					  myRisks = risks.select{|r| r.risk_category.id_padre == cat.id}

					  myRisks.each do |risk|
					    if parsedRisks.include?(risk.id.to_s)
					      lineHtml = '<span style="font-style:italic;color:#AAA;font-size:12px;">- ' << risk.descripcion << '</span><br>'
					      fileHtml.puts lineHtml
					    end
					  end


					end # Close categories

					lineHtml = '</div>'
					fileHtml.puts lineHtml # Close related risks

					lineHtml = '</div>'
					fileHtml.puts lineHtml

				end # Close findings

				lineHtml = '</div>'
				fileHtml.puts lineHtml # Close finding's dialog

			end
			# ----- map.map_type

			# ES: Obtiene las estructuras presentes en los detalles:
			# EN: Get the structures from the details:
	        estsShow = details.map {|d| d.governance_structure}
	        estsShow.uniq!
	        estsShow.compact!

	        # ES: Construye los divs del dialogo de funciones (todos escondidos)
	        # EN: Build the divs of the responsibilities dialog (all hidden)
	        lineHtml = '<div id="dialogFuncs" style="font-size:12px;">'
	        fileHtml.puts lineHtml

	        estsShow.each do |est|
	        	lineHtml = '<div style="display:none;" id="divShow' << est.id.to_s << '">'
	        	fileHtml.puts lineHtml
	        	lineHtml = '<h3> Funciones: </h3>'
	        	fileHtml.puts lineHtml
	        	funcs = get_functions_method(est.id) 
	        	if funcs.size == 0
	        		lineHtml = '<span style="color:#333;"><i>- This structure has no defined responsibilities</i></span><br>'
	        		fileHtml.puts lineHtml
	        	else
	        		error = false
	        		funcs.each do |f|
	        			# ES: Verifica que no sea el registro de separacion de errores
	        			# EN: Verify that is not the separator record
	        			if f == '#$%&/()='
	        				error = true
							lineHtml = '<h3 style="color:red;">Conflicts founded:</h3>'
							fileHtml.puts lineHtml
							next
	        			end

	        			# ES: Renderiza las funciones o los errores según sea adecuado:
	        			# EN: Renders the responsibilities or errors depending:
	        			if error
	        				# ES: Formatea el contenido de los errores:
	        				# EN: Formats the content of the errors:
	        				partes = f.split("|")
	        				lineHtml = '<span style="color:red;"><i>- ' << partes[0] << ', conflict with the next structures: </i></span><br>'
	        				fileHtml.puts lineHtml

	        				for i in 1..(partes.size - 1)
	        					lineHtml = '<span style="color:red;margin-left:15px;"><i>- ' << partes[i] << '</i></span><br>'
	        					fileHtml.puts lineHtml
	        				end

	        			else
	        				# ES: Renderiza las funciones normalmente:
	        				# EN: Renders the responsibilities normally:
	        				lineHtml = '<span style="color:#333;"><i>- ' << f << '</i></span><br>'
	        				fileHtml.puts lineHtml
	        			end
	        		end # Close funcs
	        	end # Close funcs.size == 0

	        	lineHtml = '</div>' # ES: Cierra el div de cada estructura - EN: Close the div of each structure
	        	fileHtml.puts lineHtml


	        end # Close structures

	        lineHtml = '</div>' # ES: Cierra el div del dialogo - EN: Close the dialog's div
	        fileHtml.puts lineHtml


			lineHtml = '</body></html>'
	        fileHtml.puts lineHtml
	        fileHtml.close()
	    end 
	    # ----- mapas.each 

	    # ES: Devuelve el arreglo que contiene el log
	    # EN: Returns the array that contains the log
	    return log   

  	end
  	# ----------- mapasGenerateMapFile

  	# ES: Renderiza el mapa de decisiones (Arquetipos) de manera recursiva:
  	# EN: Renders the decision maps (archetypes) recursively:
	def renderTableDec(file, decision, divs, lvl, details)
		myFile = file 
		myDec = decision
		myDivs = divs # ES: Número de <td>, por los arquetipos - EN: Number of <td>, because the archetypes
		hijos = GovernanceDecision.where("parent_id = ?", myDec.id)
		myLvl = lvl

		lineHtml = '<tr>'
		myFile.puts lineHtml

		if myLvl > 0 # ES: Debe enfatizar la jerarquia - EN: Needs to emphasize the hierarchy
			margen = myLvl * 15
			lineHtml = '<td style="background-color:#f5f5f5;border:solid 1px #cacaca;">'
			myFile.puts lineHtml
			lineHtml = '<img src="../images/right.png" style="margin-left:' << margen.to_s << 'px;"> ' << myDec.description << '</td>'
			myFile.puts lineHtml
		else
			lineHtml = '<td style="background-color:#f5f5f5;border:solid 1px #cacaca;">' << myDec.description << '</td>'
			myFile.puts lineHtml
		end

		for i in 1..myDivs # i: ES: ID del arquetipo - EN: Archetype ID
			seleccionadas = details.select { |d|  d.governance_decision.id == myDec.id && d.decision_archetype.id == i }
			lineHtml = '<td>'
			myFile.puts lineHtml
			seleccionadas.each do |sel|
				idStr = 'par_' << sel.governance_structure.id.to_s << '_' << myDec.id.to_s << '_' << i.to_s
				lineHtml = '<p title="Show responsibilities" class="showFuncs" id="' << idStr << '">- ' << sel.governance_structure.name << '</p>'
			    myFile.puts lineHtml
			end
			lineHtml = '</td>'
			myFile.puts lineHtml
		end

		lineHtml = '</tr>'
		myFile.puts lineHtml

		# ES: Renderiza los hijos:
		# EN: Renders the sons:
		if hijos.size > 0
			myLvl = lvl + 1
			hijos.each do |h|
				renderTableDec(myFile, h, myDivs, myLvl, details) 
			end
		end

	end
	# -------- renderTableDec

	# ES: Renderiza el mapa de decisiones (Delegación de responsabilidades) de manera recursiva:
	# EN: Renders the decision maps (Responsibilities delegation) recursivey:
  def renderTableDec2(file, decision, divs, lvl, details, map)
    resps = [DELEG_RESP_1,DELEG_RESP_2,DELEG_RESP_3,DELEG_RESP_4,DELEG_RESP_5]
    myFile = file
    myDec = decision
    myDivs = divs # ES: Número de <td>, por los arquetipos - EN: Number of <td>, because the archetypes
    hijos = GovernanceDecision.where("parent_id = ?", myDec.id)
    myLvl = lvl
    idSpan = 'span_' << myDec.id.to_s
    classSpan = 'span_finding_static'
    hallazgos = Finding.where("decision_map_id = ? AND governance_decision_id = ?", map.id, myDec.id).first

    if hallazgos.nil?
	    hallazgos = false
	    classSpan = ''
    else
    	hallazgos = true
    end

    lineHtml = '<tr>'
    myFile.puts lineHtml

    if myLvl > 0 # ES: Debe enfatizar la jerarquia - EN: Needs to emphasize the hierarchy
	    margen = myLvl * 15
	    lineHtml = '<td style="background-color:#f5f5f5;border:solid 1px #cacaca;width:30%;">'
	    myFile.puts lineHtml
	    lineHtml = '<div style="width:100%;text-align:right;">'
	    myFile.puts lineHtml
	    lineHtml = '<span id="' << idSpan << '" class="' <<  classSpan << '" style="color:#428bca;cursor:pointer;margin:3px 0 3px 0;">'
	    myFile.puts lineHtml

	    if hallazgos
	      lineHtml = 'Ver hallazgos'
	      myFile.puts lineHtml
	    end

	    lineHtml = '</span></div><div>'
	    myFile.puts lineHtml
	    lineHtml = '<img src="../images/right.png" style="margin-left:' << margen << 'px;">' << myDec.description << '</div></td>'
	    myFile.puts lineHtml
    else
	    lineHtml = '<td style="background-color:#f5f5f5;border:solid 1px #cacaca;">'
	    myFile.puts lineHtml
	    lineHtml = '<div style="width:100%;text-align:right;">'
	    myFile.puts lineHtml
	    lineHtml = '<span id="' << idSpan << '" class="' << classSpan << '" style="color:#428bca;cursor:pointer;margin:3px 0 3px 0;">'
	    myFile.puts lineHtml

	    if hallazgos
	      lineHtml = 'Show findings'
	      myFile.puts lineHtml
	    end

	    lineHtml = '</span></div><div>' << myDec.description << '</div></td>' 
	    myFile.puts lineHtml
    end

    for i in 1..myDivs # i: ES: ID del tipo de responsabilidad - EN: Responsibility Type ID
	    seleccionadas = details.select { |d|  d.governance_decision.id == myDec.id && d.responsability_type == resps[i-1] } 

	    if i == myDivs
	    	mech = seleccionadas.first
	       	if !mech.nil?
	       		mechs = mech.complementary_mechanisms
	       		if !mechs.nil? && mechs != ''
	    	   		# ES: Hay mecanismos cargados
	    	   		# EN: There are loaded mechanisms
	    	   		loadedMechs = mechs.split("|")
	       	    end
	       	end
	    end

	    lineHtml = '<td>'
	    myFile.puts lineHtml
	    if !loadedMechs.nil?
	      	myMechs = ComplementaryMechanism.where(id: loadedMechs)
	    	myMechs.each do |mech|
	    		lineHtml = '<p class="cell">- ' << mech.description << '</p>'
	    		myFile.puts lineHtml
	    	end
	    else
	    	seleccionadas.each do |sel|
	    		idStr = 'par_' << sel.governance_structure.id.to_s << '_' << myDec.id.to_s << '_' << i.to_s
	    		lineHtml = '<p title="Show responsibilities" class="showFuncs" id="' << idStr << '">- ' << sel.governance_structure.name << '</p>'
	    		myFile.puts lineHtml
	    	end
	    	
	    end

	    lineHtml = '</td>'
	    myFile.puts lineHtml
    end

    lineHtml = '</tr>'
    myFile.puts lineHtml

    # ES: Renderiza los hijos:
    # EN: Renders the sons:
    if hijos.size > 0
	    myLvl = lvl + 1
	    hijos.each do |h|
	    	renderTableDec2(myFile, h, myDivs, myLvl, details, map)
	    end
    end # ----- hijos.size > 0

  end
  # ------- renderTableDec2




  	# ES: Metodos privados:
  	# EN: Private methods:
	def darHijosD(decision)
		return GovernanceDecision.where("parent_id = ?", decision.id)		
	end
	# --------

	# ES: Obtiene el contenido HTML de la identificacion de un arquetipo:
	# EN: Get the HTML content of the archetype identification:
	def identify_archetype_method(idMapas)
		mapas = DecisionMap.where(id: idMapas)
		dimensiones = [DIM_DEC_1, DIM_DEC_2, DIM_DEC_3, DIM_DEC_4, DIM_DEC_5]

		lineaVertical = DecisionArchetype.all.size

		# ES: Arreglo para ir acumulando todas las estadisticas de consultado (en forma de pila por dimension)
		# EN: Array to accumulate the "consulted" statistics (as a stack by dimension)
		totalStatsConsultado = []
		# ES: Arreglo para ir acumulando todas las estadisticas de decide (en forma de pila por dimension) 
		# EN: Array to accumulate the "decides" statistics (as a stack by dimension)
		totalStatsDecide = [] 

		# ES: Recorre por cada mapa y dimension, para obtener sus estadisticas:
		# EN: Go through each map and dimension, to get its statistics:
		mapas.each do |mapa|

			consultadoMapa = []
			decideMapa = []

			dimensiones.each do |dim|
				archetypeArray = get_archetype_stats(dim, mapa)
				decideMapa.concat(archetypeArray[1])
				consultadoMapa.concat(archetypeArray[0])
			end

			totalStatsDecide.push(decideMapa)
			totalStatsConsultado.push(consultadoMapa)
		end

		# ES: Al final ya tiene en ambos arreglo todos los valores apilados, debe formatearlo para ponerlos en linea y no en pila:
		# EN: At the end, in both arrays are all the values stacked, need to format them to put them in line and not as a stack:
		formated = []		

		for i in 0..lineaVertical 

			for h in 0..(mapas.size - 1)

				for k in 0..(dimensiones.size - 1)
				temp = lineaVertical + 1 
				temp = (k * 7) + i

				element = totalStatsDecide[h][temp]
				formated.push(element)
				element = totalStatsConsultado[h][temp]
				formated.push(element)

				end # k
			end # h
		end # i



		return formated

	end # ES: FIN METODO - EN: END METHOD
	# ------------

	# ES: Metodo que dada una dimension y un mapa de decision, devuelve los porcentajes de concordancia de cada arquetipo
	# EN: Method that given a dimension and a decision map, returns the concordance percentages for each archetype 
	def get_archetype_stats(dim, mapa)
		arquetipos = DecisionArchetype.all
		# ES: Agrega un arquetipo temporal, que define los valores No Aplica - No Existe y Vacío
		# EN: Adds a temporary archetype, that defines the values "Not Available" - "Not Existent" and "Empty"
		archTemp = DecisionArchetype.new
		archTemp.name = "N/A"
		arquetipos.push(archTemp)

		consultado = DELEG_RESP_3
		decide = DELEG_RESP_1

		# ES: Variables que por dimension modelan el número de decisiones vacías (sin responsables)
		# EN: Variables that by dimension model the number of empty decisions (without any responsible)
		emptyConsultado = 0
		emptyDecide = 0

		# ES: Obtiene los ids de TODAS las decisiones de la dimension para esa empresa:
		# EN: Get the ids of ALL decisions of the dimension for that enterprise:
		decsByDim = GovernanceDecision.where(dimension: dim, enterprise_id: mapa.enterprise.id)
		decsByDim = decsByDim.map {|dec| dec.id}

		# ES: Obtiene TODOS los detalles del mapa, en "Consultado", y relacionados a alguna decision de la dimension:
		# EN: Get ALL the map details, on "Consulted", and related at any decision of the dimension:
		consultadoTotal = MapDetail.where(decision_map_id: mapa.id, responsability_type: consultado, governance_decision_id: decsByDim)
		
		# ES: Mapea los IDS de las decisiones que han sido detalladas:
		# EN: Map the IDS of the decision that have been detailed:
		decsConsultadoIds = consultadoTotal.map {|detail| detail.governance_decision_id}
		# ES: Obtiene las decisiones DEPURADAS (Sin repetidas) que han sido detalladas en el mapa:
		# EN: Get the decisiones FILTERED (withput repeated ones) that have been detailed in the map:
		decsConsultado = GovernanceDecision.where(id: decsConsultadoIds).uniq
		# ES: El total para "Consultado", será el número de decisiones de esa dimension, que han sido detalladas:
		# EN: The total for "Consulted", will be the number of decisions of that dimension, that have been detailed:
		dimConsultadoTotal = decsByDim.size
		decsConsultado.size == 0 ? contDec = 0 : contDec = decsConsultado.size 
		emptyConsultado = decsByDim.size - contDec


		# ES: Obtiene TODOS los detalles del mapa, en "Decide", y relacionados a alguna decision de la dimension:
		# EN: Get ALL the map details, on "Decides", and related at any decision of the dimension:
		decideTotal = MapDetail.where(decision_map_id: mapa.id, responsability_type: decide, governance_decision_id: decsByDim)
		
		# ES: Mapea los IDS de las decisiones que han sido detalladas:
		# EN: Map the IDS of the decision that have been detailed:
		decsDecideIds = decideTotal.map {|detail| detail.governance_decision_id}
		# ES: Obtiene las decisiones DEPURADAS (Sin repetidas) que han sido detalladas en el mapa:
		# EN: Get the decisiones FILTERED (withput repeated ones) that have been detailed in the map:
		decsDecide = GovernanceDecision.where(id: decsDecideIds).uniq
		# ES: El total para "Decide", será el número de decisiones de esa dimension, que han sido detalladas:
		# EN: The total for "Decides", will be the number of decisions of that dimension, that have been detailed:
		dimDecideTotal = decsByDim.size
		decsDecide.size == 0 ? contDec = 0 : contDec = decsDecide.size 
		emptyDecide = decsByDim.size - contDec

		# ES: Arreglos para llevar el calculo de cuantas decisiones caen en cada arquetipo
		# EN: Arrays to count the number of decisions of each archetype

		# ES: Cada posicion para cada arquetipo en el orden que vengan
		# EN: Each position for each archetype in the coming order
		statsConsultado = [0, 0, 0, 0, 0, 0, 0] 
		# ES: Cada posicion para cada arquetipo en el orden que vengan
		# EN: Each position for each archetype in the coming order
		statsDecide = [0, 0, 0, 0, 0, 0, 0] 

		# ES: Indices para controlar la ubicacion de cada arquetipo:
		# EN: Indexes to control the location of each archetype:
		indexMB = 0  # ES: Monarquia de Negocio - EN: Business Monarchy
		indexMTI = 0 # ES: Monarquia de TI - EN: IT Monarchy
		indexFed = 0 # ES: Federal - EN: Federal
		indexDuo = 0 # ES: Duopolio de TI - EN: IT Duopoly
		indexFeu = 0 # ES: Feudal - EN: Feudal
		indexAna = 0 # ES: Anarquia - EN: Anarchy
		indexNA = 0  # ES: N/A - EN: N/A

		# ES: Asigna los indices:
		# EN: Assign the indexes:
		arquetipos.each_with_index do |arch, i|
			case arch.name
			when 'Business Monarchy'
				indexMB = i
			when 'IT Monarchy'
				indexMTI = i
			when 'Federal'
				indexFed = i
			when 'IT Duopoly'
				indexDuo = i
			when 'Feudal'
				indexFeu = i
			when 'Anarchy'
				indexAna = i
			when 'N/A'
				indexNA = i
			end
		end


		# ==================== ES: CONSULTADO - EN: CONSULTED ==================== #
		# ES: Recorre cada decision en consultado, y cuando concuerde con un arquetipo, va sumando su valor:
		# EN: Go through each decision under "consulted", and when any fits an archetype, adds up its value:
		decsConsultado.each do |dec|

			detailTemp = consultadoTotal.select{|det| det.governance_decision_id == dec.id}
			respsIds = detailTemp.map {|det| det.governance_structure_id}
			responsables = GovernanceStructure.where(id: respsIds)
			myProfiles = responsables.map {|resp| resp.profile}

			# ES: Las siguientes variables definen la existencia y cantidad de cada perfil:
			# EN: The next variables define the existence and quantity for each profile:
			ejecTI = 0
			personalTI = 0
			liderUN = 0
			processOw = 0
			ejecNegocio = 0
			negocioTI = 0
			grupoUN = 0
			individuos = 0
			noExiste = 0
			# ES: Las siguientes variables controlan la exclusion de perfiles en determinados casos:
			# EN: The next variables control the exclusion of profiles in certain cases:
			otrosMonTI = false  # ES: Otros para Monarquia de TI - EN: Others for IT Monarchy
			otrosDuoTI = false  # ES: Otros para Duopolio de TI - EN: Others for IT Duopoly
			otrosFeudal = false # ES: Otros para Feudal - EN: Others for Feudal

			# ES: Se recorren los perfiles y asignan segun sea el caso
			# EN: Go through the profiles and assign according the case
			myProfiles.each do |perfil|
				case perfil
				when PERFIL_EST_1
					ejecTI += 1
					otrosFeudal = true

				when PERFIL_EST_2
					personalTI += 1
					otrosFeudal = true

				when PERFIL_EST_3
					negocioTI += 1
					otrosMonTI = true
					otrosFeudal = true

				when PERFIL_EST_4
					liderUN += 1
					otrosMonTI = true

				when PERFIL_EST_5
					grupoUN += 1
					otrosMonTI = true
					otrosDuoTI = true
					otrosFeudal = true

				when PERFIL_EST_6
					processOw += 1
					otrosMonTI = true

				when PERFIL_EST_7
					individuos += 1
					otrosMonTI = true
					otrosDuoTI = true
					otrosFeudal = true

				when PERFIL_EST_8
					ejecNegocio += 1
					otrosMonTI = true

				when PERFIL_EST_9
					noExiste += 1
					otrosMonTI = true
					otrosDuoTI = true
					otrosFeudal = true
				end
			end

			# ES: Con los perfiles se procede a validar cada regla, y si concuerda lo asigna y deja de buscar:
			# EN: With the profiles, proceed to validate each rule, and if fits any of them, stop searching the archetype:

			# ========== ES: MONARQUIA DE NEGOCIO - EN: BUSINESS MONARCHY
			if (myProfiles.size == 1) && (myProfiles[0] == PERFIL_EST_8)
				# ES: Regla: Monarquia de Negocio
				# EN: Rule: Business Monarchy
				statsConsultado[indexMB] += 1

			# ========= ES: MONARQUIA DE TI - EN: IT MONARCHY
			elsif !otrosMonTI
				if (ejecTI > 0 || personalTI > 0)
					# ES: Regla: Monarquia de TI
					# EN: Rule: IT Monarchy
					statsConsultado[indexMTI] += 1
				else
					statsConsultado[indexFeu] += 1
				end 

			# ========= FEDERAL
			elsif grupoUN > 0
				# ES: Regla: Federal
				# EN: Rule: Federal
				statsConsultado[indexFed] += 1

			# ========= ES: DUOPOLIO DE TI - EN: IT DUOPOLY
		    elsif !otrosDuoTI
				# ES: (Ejecutivo de TI | Personal de TI) & (Líder Unidad de Negocio | Dueño(s) de proceso )
				# EN: (IT Executive | IT Staff) & (Business Unit Leader | Process Owner(s) )
				if ( (ejecTI > 0 || personalTI > 0) && (liderUN > 0 || processOw > 0))
					statsConsultado[indexDuo] += 1
				# ES: (Ejecutivo de TI | Personal de TI) & (Ejecutivo de Negocio)
				# EN: (IT Executive | IT Staff) & (Business Executive)
				elsif ( (ejecTI > 0 || personalTI > 0) && ejecNegocio > 0)
					statsConsultado[indexDuo] += 1
				# ES: Negocio-TI (PERFIL_EST_3) -> Selección automática
				# EN: Business-IT (PERFIL_EST_3) -> Automatic selection
				elsif negocioTI > 0
					statsConsultado[indexDuo] += 1
				else
					statsConsultado[indexFeu] += 1
				end

			# ========== FEUDAL
		    elsif !otrosFeudal
				# ES: Líder de Unidad de Negocio (PERFIL_EST_4) ó Dueño(s) de proceso (PERFIL_EST_6)
				# EN: Business Unit Leader (PERFIL_EST_4) or Process Owner(s) (PERFIL_EST_6)
				if ( (liderUN > 0 || processOw > 0 ) )
					statsConsultado[indexFeu] += 1
				# ES: Varios Ejecutivos de Negocio (PERFIL_EST_8)
				# EN: Group of Business Executives (PERFIL_EST_8)
				elsif ejecNegocio > 1
					statsConsultado[indexFeu] += 1
				else
					statsConsultado[indexFeu] += 1
				end

			# ========== ES: ANARQUIA - EN: ANARCHY
		    elsif individuos > 0
				statsConsultado[indexAna] += 1

			# ========= ES: NO EXISTE/NO APLICA - EN: NOT EXISTENT/NOT AVAILABLE
		    elsif noExiste > 0
				statsConsultado[indexNA] += 1

			# ======== ES: FINAL, NO ENTRO A NINGUNA REGLA, LO ASIGNA A FEUDAL
			# ======== EN: FINAL, NO RULE ACCOMPLISHED, ASSIGN IT TO FEUDAL
		    else
		    	statsConsultado[indexFeu] += 1
			end


		end # decsConsultado.each

		# ES: Al finalizar de recorrer las decisiones de consultado en el arreglo statsConsultado están los resultados
		# EN: At the end of the loop of consulte decisions, in the array "statsConsultado" are the results

		# ==================== ES: DECIDE - EN: DECIDES ==================== #
		# ES: Recorre cada decision en decide, y cuando concuerde con un arquetipo, va sumando su valor:
		# EN: Go through each decision in "decides" and when any fits an archetype, adds up its value:
		decsDecide.each do |dec|

			detailTemp = decideTotal.select{|det| det.governance_decision_id == dec.id}
			respsIds = detailTemp.map {|det| det.governance_structure_id}
			responsables = GovernanceStructure.where(id: respsIds)
			myProfiles = responsables.map {|resp| resp.profile}

			# ES: Obtiene los perfiles de consultado para esta decision, pues se utilizan en el algoritmo:
			# EN: Get the profiles of "consulted" for this decision, given the fact that are reequired for the algorithm:
			consultadoProfiles = consultadoTotal.select{|det| det.governance_decision_id == dec.id}
			consultadoProfiles = consultadoProfiles.map {|det| det.governance_structure_id}
			consultadoProfiles = GovernanceStructure.where(id: consultadoProfiles)
			consultadoProfiles = consultadoProfiles.map {|resp| resp.profile}
			# ES: Elimina de los perfiles de consultado los valores No Existe y No Aplica:
			# EN: Delete from the "consulted" profiles the values Not Existen and Not Available:
			consultadoProfiles.delete_if {|perfil| perfil == PERFIL_EST_9 }

			if consultadoProfiles.size == 0
				# ES: No es consultado por nadie, es Feudal si decide más de una estructura:
				# EN: Is not consulted by anyone, is Feudal if more than 1 structure decides:
				if myProfiles.size > 1
					statsDecide[indexFeu] += 1
				else
					# ES: Decide sólo una estructura, toma su perfil y lo asocia a un arquetipo
					# EN: Decides only 1 structure, take its profile and associate it to an archetype
					perfil = myProfiles[0]
					case perfil
					when PERFIL_EST_1, PERFIL_EST_2
						statsDecide[indexMTI] += 1
					when PERFIL_EST_3
						statsDecide[indexDuo] += 1
					when PERFIL_EST_4, PERFIL_EST_6
						statsDecide[indexFeu] += 1
					when PERFIL_EST_5
						statsDecide[indexFed] += 1					
					when PERFIL_EST_7
						statsDecide[indexAna] += 1
					when PERFIL_EST_8
						statsDecide[indexMB] += 1
					when PERFIL_EST_9
						statsDecide[indexNA] += 1
					else
						statsDecide[indexDuo] += 1
					end
				
				end				
			else
				# ES: Si es consultado por alguien, procede a evaluar las reglas normales:
				# EN: If it's consulted by anyone, proceed to evaluate the regular rules:

				# ES: Las siguientes variables definen la existencia y cantidad de cada perfil:
				# EN: The next variables define the existence and quantity for each profile:

				ejecTI = 0
				personalTI = 0
				liderUN = 0
				processOw = 0
				ejecNegocio = 0
				negocioTI = 0
				grupoUN = 0
				individuos = 0
				noExiste = 0
				# ES: Las siguientes variables controlan la exclusion de perfiles en determinados casos:
				# EN: The next variables control the exclusion of profiles in certain cases:
				otrosMonTI = false  # ES: Otros para Monarquia de TI - EN: Others for IT Monarchy
				otrosDuoTI = false  # ES: Otros para Duopolio de TI - EN: Others for IT Duopoly
				otrosFeudal = false # ES: Otros para Feudal - EN: Others for Feudal
				# ES: Las siguientes variables controlan la exclusion de perfiles en determinados casos de consultado:
				# EN: The next variables control the exclusion of profiles in certain cases:
				otrosMonTIConsultado = false  # ES: Otros para Monarquia de TI - EN: Others for IT Monarchy
				otrosDuoTIConsultado = false  # ES: Otros para Duopolio de TI - EN: Others for IT Duopoly
				otrosFeudalConsultado = false # ES: Otros para Feudal - EN: Others for Feudal

				# ES: Se recorren los perfiles y asignan segun sea el caso
				# EN: Go through the profiles and assign according the case
				myProfiles.each do |perfil|
					case perfil
					when PERFIL_EST_1
						ejecTI += 1
						otrosFeudal = true

					when PERFIL_EST_2
						personalTI += 1
						otrosFeudal = true

					when PERFIL_EST_3
						negocioTI += 1
						otrosMonTI = true
						otrosFeudal = true

					when PERFIL_EST_4
						liderUN += 1
						otrosMonTI = true

					when PERFIL_EST_5
						grupoUN += 1
						otrosMonTI = true
						otrosDuoTI = true
						otrosFeudal = true

					when PERFIL_EST_6
						processOw += 1
						otrosMonTI = true

					when PERFIL_EST_7
						individuos += 1
						otrosMonTI = true
						otrosDuoTI = true
						otrosFeudal = true

					when PERFIL_EST_8
						ejecNegocio += 1
						otrosMonTI = true

					when PERFIL_EST_9
						noExiste += 1
						otrosMonTI = true
						otrosDuoTI = true
						otrosFeudal = true
					end
				end

				# ES: Se recorren los perfiles consultado y asignan segun sea el caso
				# EN: Go through the "consulted" profiles and assign according the case
				consultadoProfiles.each do |perfil|
					case perfil
					when PERFIL_EST_1
						otrosFeudalConsultado = true
					when PERFIL_EST_2
						otrosFeudalConsultado = true
					when PERFIL_EST_3
						otrosMonTIConsultado = true
						otrosFeudalConsultado = true
					when PERFIL_EST_4
						otrosMonTIConsultado = true
					when PERFIL_EST_5
						otrosMonTIConsultado = true
						otrosDuoTIConsultado = true
						otrosFeudalConsultado = true
					when PERFIL_EST_6
						otrosMonTIConsultado = true
					when PERFIL_EST_7
						otrosMonTIConsultado = true
						otrosDuoTIConsultado = true
						otrosFeudalConsultado = true
					when PERFIL_EST_8
						otrosMonTIConsultado = true
					when PERFIL_EST_9
						otrosMonTIConsultado = true
						otrosDuoTIConsultado = true
						otrosFeudalConsultado = true
					end
				end


				# ES: Con los perfiles se procede a validar cada regla, y si concuerda lo asigna y deja de buscar:
				# EN: With the profiles, proceed to validate each rule, and if fits any of them, stop searching the archetype:

				# ========== ES: MONARQUIA DE NEGOCIO - EN: BUSINESS MONARCHY
				if (myProfiles.size == 1) && (myProfiles[0] == PERFIL_EST_8)
					# ES: Regla: Monarquia de Negocio
					# EN: Rule: Business Monarchy
					statsDecide[indexMB] += 1

				# ========= ES: MONARQUIA DE TI - EN: IT MONARCHY
				elsif !otrosMonTI
					if ( (ejecTI > 0 || personalTI > 0) && !otrosMonTIConsultado )
						# ES: Regla: Monarquia de TI
						# EN: Rule: IT Monarchy
						statsDecide[indexMTI] += 1
					else
						statsDecide[indexDuo] += 1
					end 

				# ========= FEDERAL
				elsif grupoUN > 0
					if consultadoProfiles.include?(PERFIL_EST_5)
						# ES: Regla consultado: Le consulta al menos a 1, y concuerda con Federal
						# EN: Consulted rule: Consults at least 1, and fits in Federal
						statsDecide[indexFed] += 1
					else
						statsDecide[indexDuo] += 1
					end
					
				# ========= ES: DUOPOLIO DE TI . EN: IT DUOPOLY
			    elsif !otrosDuoTI
					# ES: (Ejecutivo de TI | Personal de TI) & (Líder Unidad de Negocio | Dueño(s) de proceso )
					# EN: (IT Executive | IT Staff) & (Business Unit Leader | Process Owner(s) )
					if ( (ejecTI > 0 || personalTI > 0) && (liderUN > 0 || processOw > 0))
						statsDecide[indexDuo] += 1
					# ES: (Ejecutivo de TI | Personal de TI) & (Ejecutivo de Negocio)
					# EN: (IT Executive | IT Staff) & (Business Executive)
					elsif ( (ejecTI > 0 || personalTI > 0) && ejecNegocio > 0)
						statsDecide[indexDuo] += 1
					# ES: Negocio-TI (PERFIL_EST_3) -> Selección automática
					# EN: Business-IT (PERFIL_EST_3) -> Automatic selection
					elsif negocioTI > 0
						statsDecide[indexDuo] += 1
					else
						statsDecide[indexDuo] += 1
					end

				# ========== FEUDAL
			    elsif !otrosFeudal
					# ES: Líder de Unidad de Negocio (PERFIL_EST_4) ó Dueño(s) de proceso (PERFIL_EST_6)
					# EN: Business Unit Leader (PERFIL_EST_4) or Process Owner(s) (PERFIL_EST_6)
					if ( (liderUN > 0 || processOw > 0 ) )
						statsDecide[indexFeu] += 1
					# ES: Varios Ejecutivos de Negocio (PERFIL_EST_8)
					# EN: Group of Business Executives (PERFIL_EST_8)
					elsif ejecNegocio > 1
						statsDecide[indexFeu] += 1
					else
						statsDecide[indexDuo] += 1
					end

				# ========== ES: ANARQUIA - EN: ANARCHY
			    elsif individuos > 0
					statsDecide[indexAna] += 1

				# ========= ES: NO EXISTE/NO APLICA - EN: NOT EXISTENT/NOT AVAILABLE
			    elsif noExiste > 0
					statsDecide[indexNA] += 1

				# ======== ES: FINAL, NO ENTRO A NINGUNA REGLA ANTES, LO ASIGNA A DUOPOLIO
				# ======== EN: FINAL, NO RULE ACCOMPLISHED, ASSIGN IT TO FEUDAL
			    else
			    	statsDecide[indexDuo] += 1
				end
				
			end


		end # decsDecide.each

		# ES: Suma los valores No Aplica y No Existe con los inexistentes:
		# EN: Sums up the values Not Available and Not Existent with the empty ones:
		statsConsultado[indexNA] += emptyConsultado
		statsDecide[indexNA] += emptyDecide

		# ES: En este punto ya se tienen las estadisticas tanto de consultado, como de decide, se deben formatear como porcentajes:
		# EN: At this point, we got the statistics of "consulted", and "decides", format them as percentages:

		# ES: Calcula los 2 mayores valores de decide:
		# EN: Calculates the 2 higher values of decides:
		mayor = 0
		mayor2 = 0
		
		temp = statsDecide
		temp = temp.sort{|a, b| b <=> a}
		
		mayor = temp[0]
		
		temp.each do |t|
			if t > mayor2 && t != mayor
				mayor2 = t
				break
			end
		end
		
		

		# ES: Formatea a porcentaje y float:
		# EN: Format as percentage and float:
		mayor = ((mayor.to_f / dimDecideTotal.to_f) * 100).round(2)
		mayor = mayor.to_s
		mayor2 = ((mayor2.to_f / dimDecideTotal.to_f) * 100).round(2)
		mayor2 = mayor2.to_s


		# ES: Formateo de consultado:
		# EN: "Consulted" formating:
		statsConsultado.each_with_index do |stat, i|
			# ES: Si el total de decisiones es 0, asigna a todo '-', de resto asigna su porcentaje
			# EN: If the total of decisions are 0, assign '-' to all, otherwise assing its percentage
			if dimConsultadoTotal == 0
				statsConsultado[i] = '-'
			else
				temp = ((stat.to_f / dimDecideTotal.to_f) * 100).round(2)
				temp = temp.to_s
				statsConsultado[i] = temp
			end
		end

		# ES: Formateo de decide:
		# EN: "Decides" formating:
		statsDecide.each_with_index do |stat, i|
			# ES: Si el total de decisiones es 0, asigna a todo '-', de resto asignasu porcentaje
			# EN: If the total of decisions are 0, assign '-' to all, otherwise assing its percentage
			if dimDecideTotal == 0
				statsDecide[i] = '-'
			else
				temp = ((stat.to_f / dimDecideTotal.to_f) * 100).round(2)
				temp = temp.to_s
				statsDecide[i] = temp
			end
		end

		# ES: Formatea los 2 mayores valores de decide para marcarlos:
		# EN: Format the 2 higher values of "decides" to mark them:
		statsDecide.each_with_index do |stat, i|
			if stat.eql?(mayor)
				statsDecide[i] = 'MR' << statsDecide[i]
			elsif stat.eql?(mayor2) && !mayor2.eql?('0.0')
				statsDecide[i] = 'MN' << statsDecide[i]
			end
		end


		# ES: Construye la respuesta, 2 arreglos, uno para consultado y otro para decide:
		# EN: Builds the answer, 2 arrays, one for "consulted" and other one for "decides":
		respuesta = [statsConsultado, statsDecide]


		return respuesta		

	end # FIN METODO
	# -----------------

	# ES: Obtiene la informacion de las funciones de una estructura, y sus conflictos (Via Método):
	# EN: Get the information of the responsibilities of a structure, and its conflicts (Through method):
	def get_functions_method(estId)
		est = GovernanceStructure.find(estId)
		emp = est.enterprise
		funcs = est.governance_responsabilities
		# ES: Para conocer los conflictos, por cada funcion saca sus responsables, depura y compara:
		# EN: To know the conflicts, for each responsibility get its responsibles, filter and compare:
		conflictos = []
		funcs.each do |f|
			ests = f.governance_structures
			# ES: Depura de las estructuras asociadas, para dejar sólo las de la misma empresa.
			# EN: Filter the related structures, to add only the ones from the enterprise
			depuradas = []

			ests.each do |est|
				# ES: Recorre todas las estructuras, si son de la misma empresa, la va agregando:
				# EN: Loop all the structures, if are of the same enterprise, add it:
				if est.enterprise_id == emp.id
					depuradas.push(est)
				end
			end

			# ES: Re-asigna:
			# EN: Re-Assign:
			ests = depuradas
			
			if ests.size > 1
				# ES: Tiene este responsable, y al menos otro adicional
				# EN: Has this responsible, and at least another one
				otros = ests.select{|o| o.id != est.id}
				temp = f.name
				otros.each do |o|
					temp+= '|' + o.name
				end

				if temp.include? '|'
					conflictos.push(temp)
				end
				# ES: String del tipo: Nombre_funcion|estructura conflictiva1|estructura conflictiva2.....
				# EN: String formated as: Responsibility_name|Conflicted Structure 1|Conflicted Structure 2....
			end
		end

		funcs = est.governance_responsabilities.map {|f| f.name}

		# ES: Si hay conflictos, los envia en el mismo arreglo, pero con un elemento de separación:
		# EN: If there are conflicts, send them in the same array, but with a separator element:
		if conflictos.size > 0
			funcs.push("#$%&/()=") # ES: Separacion - EN: Separator
			conflictos.each do |c|
				funcs.push(c)
			end
		end

		return funcs
	end
	# -------------





  end
end
