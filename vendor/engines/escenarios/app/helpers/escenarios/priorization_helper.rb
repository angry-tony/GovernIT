module Escenarios
  module PriorizationHelper

  	# ES: Obtiene la importancia de los riesgos:
  	# EN: Calculates the risk importance:
	  def get_risk_importance(escenario)
	    esc = escenario
	    escRisk = escenario.risk_escenario
	    procesos = ItProcess.all.order(id: :asc)
	    # ES: Por cada proceso calcula un valor de la siguiente manera:
	    # EN: For each process calculates a value with the proccess described next:
	    valores = []
	    # ES: Arreglo para almacenar los procesos COBIT de los riesgos calificados mas alto
	    # EN: Array to save the COBIT Processes related to the highest scored risks
	    repetidos = [] 

	    # ES: Obtiene los 5 riesgos calificados más alto por su valor de calificacion, si se repite el valor lleva todos los repetidos si es necesario:
	    # EN: Get the 5 highest ranked risks based on its scores, if there are more than 5 risks with the same score, get all of them
	    riskHigh = Risk.joins("INNER JOIN escenarios_risk_califications ON escenarios_risk_califications.risk_id = risks.id").where("escenarios_risk_califications.risk_escenario_id = ? AND risks.nivel = ?", escRisk.id ,'GENERICO').order("escenarios_risk_califications.valor DESC").take(7)
	    riskHigh.uniq!
	    riskHigh = riskHigh.map {|r| r.risk_category_id}
	    # ES: Obtiene los procesos COBIT asociados a dichos riesgos:
	    # EN: Get the COBIT Processes realted to those risks:
	    matrix = RiskProcessMatrix.where(risk_category_id: riskHigh)
	    matrix.each do |m|
	      related = m.related_processes
	      partes = related.split("|")
	      partes.each do |p|
	        repetidos.push(p)
	      end
	    end

	    repetidos.sort!{|a,b| a <=> b}
	  

	    # valor = valor1 * c1 + valor2 * c2
	    c1 = 0.5
	    c2 = 0.5

	    # ES: Como es un valor de 0-100, lo divide en 100 para luego multiplicar
	    # EN: Given the fact that the value if from 0 to 100, divide by 100 to later multiply
	    pesoRiesgos = (esc.risksWeight.to_f / 100.to_f).round(3) 
	    # ES: Para cada proceso, calcula el numero de riesgos asociados, lo multiplica por el peso, y agrega el valor al arreglo respuesta:
	    # EN: For each process, calculate the number of related risks, multiply it by the weight, and add the value to the final array:
	    procesos.each do |proc|
	      # ES:
	      # Valor1: # de riesgos asociados al proceso * peso de los riesgos para el escenario
	      # El # de riesgos asociados al proceso, se acota para que de un valor de 0-5, 0 = sin riesgos asociados, 5 = el maximo de riesgos asociados (9)
	     
	      # EN: 
	      # Valor1: # of risks related to the process * risks' weight feined for the scenario
	      # The # of risks related to the process is bounded into a range from 0 to 5, 0 = No risks related, 5 = The max number of related risks (in this case 9)

	      # ES: El identificador según la fuente: e.g -> EDM01
	      # EN: The identifier accoridng the source: e.g -> EDM01
	      nameBusq = '%' << proc.id_fuente << '%' 
	      numRisks = Risk.joins("INNER JOIN escenarios_risk_process_matrices ON escenarios_risk_process_matrices.risk_category_id = risks.risk_category_id").where("risks.nivel = ? AND escenarios_risk_process_matrices.related_processes LIKE ?", 'GENERICO', nameBusq)
	      numRisks.uniq!
	      numRisks = numRisks.size
	      # ES: Para acotar el valor de 0-5, se usa una regla de 3, acotado = (5 * numRisks)/totalMaxRisks
	      # EN: To bound the value to a range from 0 to 5, use a rule of three, bounded value = (5 * numRisks)/totalMaxRisks
	      totalRisks = 31 # ES: 31 es el maximo, por eso se define dicho valor - EN: 31 is the max value, that's why we defined that way
	      acotado = ( (5.0 * numRisks.to_f) / totalRisks.to_f ).round(3)
	      value1 = (acotado.to_f * c1).round(3)
	      # ES: Valor2: # veces que un proceso de Cobit se repite en los riesgos con mayor peso, se acota para que de un valor de 0-5, 0 = no se repite en los riesgos con mayor peso, 5 = se repite siempre
	      # EN: Value2: # of times a COBIT process is repeated in the highest ranked risks, bounded into a range from 0 to 5, 0 = No repetitions in the highest ranked risks, 5 = Always repeated
	      reps = repetidos.select{|r| r == proc.id_fuente}
	      # ES: Para acotar el valor de 0-5, se usa una regla de 3, acotado = (5 * repeticiones)/totalRepeticiones
	      # EN: To bound the value into a range from 0 to 5, use a rule of three, bounded value = (5 * numRepetitions)/totalRepetitions
	      acotado = ( (5.0 * reps.size.to_f) / repetidos.size.to_f).round(3)
	      value2 = (acotado.to_f * c2).round(3)
	      # ES: Valor:
	      # EN: Value:
	      value = ((value1 + value2) * pesoRiesgos.to_f).round(3)
	      valueString = proc.id.to_s << '|' << value.to_s
	      valores.push(valueString)
	    end
	    
	    return valores

	  end

	  # ES: Obtiene la importancia de los objetivos:
	  # EN: Get the goal importance:
	  def get_goal_importance(escenario)
	    esc = escenario
	    escObj = esc.goal_escenario # ES: Escenario de evaluacion de objetivos - EN: Goal Assessment Scenario
	    procesos = ItProcess.all.order(id: :asc)
	    pesoObjetivos = (esc.goalsWeight.to_f / 100.to_f).round(3)
	    # ES: Por cada proceso calcula un valor de la siguiente manera:
	    # EN: For each process, calculate a value with the process described below:
	    valores = []

	    # 1. Calcula los valores de P y S, para cada tipo de objetivo, y cada dimension: NO SE CALCULA, SON FIJOS
	    # 1. Calculate the P and S values, for every type of goal and every dimension: IN THIS CASE REMAINS CONSTANT, NOT CALCULATED

	    # P: 5
	    # S: 2,5
	    # N: 0

	    pGlobal = 1.0
	    sGlobal = 0.5
	    nGlobal = 0.0

	    # ========================= Objetivos de TI =============================
	    objsTI = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL) # ES: Objetivos de TI - EN: IT Goals

	    pFinIT = pGlobal  # ES: Valor P - Objetivo de TI - Dimension: Financial - EN: P Value - IT Goal - Dimension: Financial
	    sFinIT = sGlobal  # ES: Valor S - Objetivo de TI - Dimension: Financial - EN: S Value - IT Goal - Dimension: Financial

	    pCusIT = pGlobal  # ES: Valor P - Objetivo de TI - Dimension: Customer - EN: P Value - IT Goal - Dimension: Customer
	    sCusIT = sGlobal  # ES: Valor S - Objetivo de TI - Dimension: Customer - EN: S Value - IT Goal - Dimension: Customer

	    pIntIT = pGlobal  # ES: Valor P - Objetivo de TI - Dimension: Internal - EN: P Value - IT Goal - Dimension: Internal
	    sIntIT = sGlobal  # ES: Valor S - Objetivo de TI - Dimension: Internal - EN: S Value - IT Goal - Dimension: Internal

	    pLyGIT = pGlobal  # ES: Valor P - Objetivo de TI - Dimension: Learning and Growth - EN: P Value - IT Goal - Dimension: Learning and Growth
	    sLyGIT = sGlobal  # ES: Valor S - Objetivo de TI - Dimension: Learning and Growth - EN: S Value - IT Goal - Dimension: Learning and Growth

	    # ========================= Objetivos de Negocio =========================
	    objsBu = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL) # Objetivos de Negocio

	    pFinBu = pGlobal  # ES: Valor P - Objetivo de Negocio - Dimension: Financial - EN: P Value - Business Goal - Dimension: Financial
	    sFinBu = sGlobal  # ES: Valor S - Objetivo de Negocio - Dimension: Financial - EN: S Value - Business Goal - Dimension: Financial

	    pCusBu = pGlobal  # ES: Valor P - Objetivo de Negocio - Dimension: Customer - EN: P Value - Business Goal - Dimension: Customer
	    sCusBu = sGlobal  # ES: Valor S - Objetivo de Negocio - Dimension: Customer - EN: S Value - Business Goal - Dimension: Customer

	    pIntBu = pGlobal  # ES: Valor P - Objetivo de Negocio - Dimension: Internal - EN: P Value - Business Goal - Dimension: Internal
	    sIntBu = sGlobal  # ES: Valor S - Objetivo de Negocio - Dimension: Internal - EN: S Value - Business Goal - Dimension: Internal

	    pLyGBu = pGlobal  # ES: Valor P - Objetivo de Negocio - Dimension: Learning and Growth - EN: P Value - Business Goal - Dimension: Learning and Growth
	    sLyGBu = sGlobal  # ES: Valor S - Objetivo de Negocio - Dimension: Learning and Growth - EN: S Value - Business Goal - Dimension: Learning and Growth

	    # ES: Constantes: FINANCIAL, CUSTOMER, INTERNAL, L_AND_G 
	    # EN: Constants: FINANCIAL, CUSTOMER, INTERNAL, L_AND_G 

	    # 2. ES: Por cada objetivo de TI, calcula su nivel de importancia, siguiendo el siguiente proceso:
	    # Cruza cada objetivo de TI, con cada uno de los objetivos de negocio, y realiza la siguiente operación:
	    # Importancia del objetivo de negocio = A (Definida en la evaluación del escenario de objetivos)
	    # Valor de P/S de dicho objetivo de negocio = M (Calculado anteriormente)
	    # Por cada objetivo de TI, calcula su cruce A*M, y suma el total, dicho valor debe ser promediado:

	    # 2. EN: For each IT goal, calculate its importance level, following the next process:
	    # Crosses each IT goal, with each business goal, and do the next calculation:
	    # Business goal importance = A (Defined in the evaluation of the goal assessment scenario)
	    # P/S value of that business goal = M (Calculated previously)
	    # For each IT goal, calculate the value A*M, and sum up the total, that value must be averaged:

	    # ES: Calificaciones de ambos tipos de objetivos
	    # EN: Scores of both types of goals 
	    calsObj = escObj.goal_califications 
	    # ES: Arreglo con los valores parametrizados del nivel de importancia por objetivo de TI
	    # EN: Array with the parametrized goal importance values per IT goal
	    nivelesObjTI = [] 
	    # ES: Calificaciones para ese escenario, de los objetivos de TI
	    # EN: Scores for that scenario, from the IT goals
	    calsTI = calsObj.select{|c| c.goal.scope == IT_GOAL}
	    # ES: Calificaciones para ese escenario, de los objetivos de negocio 
	    # EN: Scores for that scenario, from the business goals
	    calsBu = calsObj.select{|c| c.goal.scope == B_GOAL} 

	    # ES: Carga la matriz de relaciones: Objetivos de Negocio VS Objetivos de TI
	    # EN: Load the relationships matrix: Business Goals VS IT Goals
	    negocioITMatrix = BusinessGoalItMatrix.all 
	    # ES: Carga la matriz de relaciones: Objetivos de TI VS Procesos
	    # EN: Load the relationships matrix: IT Goals VS Process
	    procesoITMatrix = ItGoalsProcessesMatrix.all  

	    objsTI.each do |objTI|
	      # ES: En este valor se irá sumando cada valor del cruce A*M para cada objetivo de TI
	      # EN: This variable will contain each value of the multiplication A*M for each IT goal
	      value = 0 

	      objsBu.each do |objBu|
	        # ES: 2.1 Obtiene la importancia del objetivo de negocio, definida en el escenario
	        # EN: 2.1 Get the business goal importance, defined in the scenario
	        cal = calsBu.select{|c| c.goal.id == objBu.id}.first
	        # ES: Si no se calificó dicho objetivo, queda en 0:
	        # EN: If that goal wasn't scored, its value is 0:
	        if cal.nil?
	          importancia = 0
	        else
	          importancia = cal.importance
	        end

	        # ES: 2.2 Obtiene el valor (P/S), del cruce recien definido:
	        # EN: 2.2 Get the (P/S) value, according to the goals involved in each iteration
	        valuePS = negocioITMatrix.select{|m| m.it_goal_id == objTI.id && m.business_goal_id == objBu.id}.first.value
	        # ES: Asigna el valor, según la dimension del objetivo de negocio:
	        # EN: Assign the value, according the business goal dimension:
	        case objBu.dimension
	        when FINANCIAL
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assing the value, according if its P,S or N
	          case valuePS
	          when 'P'
	            valuePS  = pFinBu
	          when 'S'
	            valuePS  = sFinBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when CUSTOMER
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assing the value, according if its P,S or N
	          case valuePS
	          when 'P'
	            valuePS  = pCusBu
	          when 'S'
	            valuePS  = sCusBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when INTERNAL
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assing the value, according if its P,S or N
	          case valuePS
	          when 'P'
	            valuePS  = pIntBu
	          when 'S'
	            valuePS  = sIntBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when L_AND_G
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assing the value, according if its P,S or N
	          case valuePS
	          when 'P'
	            valuePS  = pLyGBu
	          when 'S'
	            valuePS  = sLyGBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        end 

	        # ES: 2.3 Calcula el valor A*M, para ese cruce de ese objetivo de negocio:
	        # EN: 2.3 Claculates the value A*M, according to the goal involved in each iteration:
	        
	        # ES: importancia = A, valuePS = M - EN: importance = A, valuePS = M
	        value+= (importancia.to_f * valuePS.to_f)
	      end

	      # ES: Como el maximo valor que puede tomar value es 50, pero al promediar y que el maximo sea 5 debe ser 85, se suma 35 deliberadamente:
	      # EN: As the maximun value that can be assigned is 50, but to guarantee a bounded value with a maximun of 85, sum up 35 deliberately:
	      value = value + 35

	      # ES: 2.4 Al llegar a este punto, ya tiene el total, simplemente lo agrega al arreglo, en forma de string: ID_Objetivo|Valor Total
	      # EN: 2.4 At this point, the total have been already calculated, simply add it to the array as a string: Goal_ID|Total_Value
	      temp = objTI.id.to_s << '|' << value.round(3).to_s
	      valores.push(temp)
	    end

	    # ES: 3. Promedia el valor total de cada objetivo de TI, sobre el total de objetivos de negocio que fue los que se cruzaron:
	    # EN: 3. Average the total value for each IT Goal, over the whole business goals:
	    valoresPara = []

	    valores.each do |v|
	      idObj = v.split('|')[0].to_s
	      val = v.split('|')[1].to_f
	      valAvg = (val / objsBu.size.to_f).round(3)
	      newVal = idObj.to_s << '|' << valAvg.to_s
	      valoresPara.push(newVal)
	    end



	    # ES: 4. Por cada proceso, calcula su nivel de importancia, siguiendo el siguiente proceso:
	    # Cruza cada proceso, con cada uno de los objetivos de TI, y realiza la siguiente operación:
	    # Importancia del objetivo de TI = I (Definida en la evaluación del escenario de objetivos)
	    # Valor de P/S de dicho objetivo de TI = N (Calculado anteriormente en el punto 1)
	    # Nivel de importancia del objetivo de TI, promediado en el punto anterior = Z
	    # Por cada proceso, calcula su cruce I*N*Z/5, y suma el total:

	    # EN: 4. For each process, calculates its importance level, following the next process:
	    # Cross each process, with each one of the IT Goals, and performs the next operation:
	    # IT Goal importance = I (defined in the evaluation of the goal assessment scenario)
	    # P/S value of that IT Goal = N (Calcualted previously in the point 1)
	    # IT Goal importance level, averaged in the last point = Z
	    # For each process, calculate the multiplication I*N*Z/5, and sums up the total:


	    # ES: Arreglo que guarda strings con el formato: ID_Proceso|Valor Final
	    # EN: Array that saves string with the format: Process_ID|Final_Value
	    valoresFinal = [] 

	    procesos.each do |pr|
	      value = 0

	      objsTI.each do |objTI|
	        # ES: 4.1 Obtiene la importancia del objetivo de TI, definida en el escenario
	        # EN: 4.1 Gets the IT Goal importance, defined in the scenario
	        cal = calsTI.select{|c| c.goal.id == objTI.id}.first
	        # ES: Si no se calificó dicho objetivo, queda en 0:
	        # EN: If the goal wasn't scored, the value is 0:
	        if cal.nil?
	          importancia = 0
	        else
	          importancia = cal.importance
	        end

	        # ES: 4.2 Obtiene el valor (P/S), del cruce recien definido:
	        # EN: 4.2 Gets the (P/S) value, with the involved goals of the iteration:
	        valuePS = procesoITMatrix.select{|m| m.it_goal_id == objTI.id && m.process_id == pr.id}.first.value
	        # ES: Asigna el valor, según la dimension del objetivo de negocio:
	        # EN: Assigns the value, according to the business goal's dimension:
	        case objTI.dimension
	        when FINANCIAL
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assigns its value, depending on if its P, S or N
	          case valuePS
	          when 'P'
	            valuePS  = pFinIT
	          when 'S'
	            valuePS  = sFinIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when CUSTOMER
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assigns its value, depending on if its P, S or N
	          case valuePS
	          when 'P'
	            valuePS  = pCusIT
	          when 'S'
	            valuePS  = sCusIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when INTERNAL
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assigns its value, depending on if its P, S or N
	          case valuePS
	          when 'P'
	            valuePS  = pIntIT
	          when 'S'
	            valuePS  = sIntIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when L_AND_G
	          # ES: Asigna su valor, según si es P,S o N
	          # EN: Assigns its value, depending on if its P, S or N
	          case valuePS
	          when 'P'
	            valuePS  = pLyGIT
	          when 'S'
	            valuePS  = sLyGIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        end

	        # ES: 4.3 Obtiene el valor promediado para ese objetivo de TI:
	        # EN: 4.3 Get the averaged value for this IT goal:
	        valuePara = 0.0
	        valoresPara.each do |v|
	          idObj = v.split('|')[0].to_i
	          if idObj == objTI.id
	            valuePara = v.split('|')[1].to_f
	            break
	          end
	        end



	        # ES: 4.4 Calcula el valor I*N*Z, para ese cruce de ese proceso:
	        # EN: 4.4 Calculates the value I*N*Z, for this crossing of this process:
	        # ES: importancia = I, valuePS = N, valuePara = Z
	        # EN: importance = I, valuePS = N, valuePara = Z
	        valueTemp =  (importancia.to_f * valuePS.to_f * valuePara.to_f).round(3)
	        value+= valueTemp
	      end  
	      
	      # ES: Como el maximo valor de la sumatoria I*N*Z es 184,54, a partir de ahi realiza el calculo para acotar los valores de 0-5
	      # EN: Given that the max value of the operation I*N*Z is 184,54, based on that, execute the calculations to bound the value into a range from 0 to 5
	      value = ((value.round(3) * 5.0) / 184.54).round(3)
	      value = value * pesoObjetivos.to_f
	      # ES: 4.5 Al llegar a este punto, ya tiene el total, simplemente lo agrega al arreglo, en forma de string: ID_Proceso|Valor Total
	      # EN: 4.5 At this point, the total has beend calculated, simply add it to the array, as a string: Process_ID|Total Value
	      temp = pr.id.to_s << '|' << value.round(3).to_s
	      valoresFinal.push(temp)

	    end

	    return valoresFinal
	  end

	  # ES: Metodo que calcula el porcentaje de completitud de un escenario de riesgos
	  # EN: Method that calculates the completeness percentage of a risk assessment scenario
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


	  # ES: Obtiene todos los resultados de la priorizacion:
	  # EN: Gets all the prioritization results:
	  def get_priorization_stats(escenario)
	    esc = escenario
	    riskImportance = get_risk_importance(esc)
	    goalImportance = get_goal_importance(esc)
	    procesos = ItProcess.all

	    stats = []
	    # ES: Formato de respuesta:
	    # Primera posicion, el nombre del escenario:
	    # stats[0] = esc.name << '|0|0|0|9999'
	    # Segunda posicion, el peso de los riesgos:
	    # stats[1] = esc.risksWeight.to_s << '|0|0|0|9998'
	    # Tercera posicion, el peso de los objetivos:
	    # stats[2] = esc.goalsWeight.to_s << '|0|0|0|9997'

	    # EN: Answer format:
	    # First position, scenario's name:
	    # stats[0] = esc.name << '|0|0|0|9999'
	    # Second position, risks weight:
	    # stats[1] = esc.risksWeight.to_s << '|0|0|0|9998'
	    # Third position, goals weight:
	    # stats[2] = esc.goalsWeight.to_s << '|0|0|0|9997'


	    
	    # ES: Las siguientes posiciones son strings con el formato:
	    # ID_Proceso|importancia_riesgos|importancia_objetivos|importancia_total

	    #EN: The next positions are strings with the format:
	    # Process_ID|risk_importance|goals_importance|total_importance
	    riskImportance.each_with_index do |risk, index|
	      idProceso = risk.split("|")[0].to_i
	      proceso = procesos.select{|p| p.id == idProceso}.first

	      riskI = risk.split("|")[1]
	      goalI = goalImportance[index].split("|")[1]
	      totalI = riskI.to_f + goalI.to_f
	      value = proceso.id.to_s << '|' << riskI << '|' << goalI << '|' << totalI.round(3).to_s
	      stats.push(value)
	    end

	    stats.sort! {|a, b| b.split('|')[3].to_f <=> a.split('|')[3].to_f}

	    resp = ''
	    separador = '_$$_'
	    stats.each do |s|
	      resp = resp << s << separador
	    end

	    # ES: Elimina el ultimo separador:
	    # EN: Removes the last separator:
	    resp = resp[0, resp.length - 4]

	    return resp

	  end
	  # ------------











  end
end
