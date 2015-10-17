module Escenarios
  module PriorizationHelper

  	# Obtiene la importancia de los riesgos:
	  def get_risk_importance(escenario)
	    esc = escenario
	    escRisk = escenario.risk_escenario
	    procesos = ItProcess.all.order(id: :asc)
	    # Por cada proceso calcula un valor de la siguiente manera:
	    valores = []
	    repetidos = [] # Arreglo para almacenar los procesos COBIT de los riesgos calificados mas alto

	    # Obtiene los 5 riesgos calificados más alto por su valor de calificacion, si se repite el valor lleva todos los repetidos si es necesario:
	    riskHigh = Risk.joins("INNER JOIN escenarios_risk_califications ON escenarios_risk_califications.risk_id = risks.id").where("escenarios_risk_califications.risk_escenario_id = ? AND risks.nivel = ?", escRisk.id ,'GENERICO').order("escenarios_risk_califications.valor DESC").take(7)
	    riskHigh.uniq!
	    riskHigh = riskHigh.map {|r| r.risk_category_id}
	    # Obtiene los procesos COBIT asociados a dichos riesgos:
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


	    pesoRiesgos = (esc.risksWeight.to_f / 100.to_f).round(3) # Como es un valor de 0-100, lo divide en 100 para luego multiplicar
	    # Para cada proceso, calcula el numero de riesgos asociados, lo multiplica por el peso, y agrega el valor al arreglo respuesta:
	    procesos.each do |proc|
	      # Valor1: # de riesgos asociados al proceso * peso de los riesgos para el escenario
	      # El # de riesgos asociados al proceso, se acota para que de un valor de 0-5, 0 = sin riesgos asociados, 5 = el maximo de riesgos asociados (9)
	      nameBusq = '%' << proc.id_fuente << '%' # El identificador según la fuente: e.g -> EDM01
	      numRisks = Risk.joins("INNER JOIN escenarios_risk_process_matrices ON escenarios_risk_process_matrices.risk_category_id = risks.risk_category_id").where("risks.nivel = ? AND escenarios_risk_process_matrices.related_processes LIKE ?", 'GENERICO', nameBusq)
	      numRisks.uniq!
	      numRisks = numRisks.size
	      # Para acotar el valor de 0-5, se usa una regla de 3, acotado = (5 * numRisks)/totalMaxRisks
	      totalRisks = 31 # 31 es el maximo, por eso se define dicho valor
	      acotado = ( (5.0 * numRisks.to_f) / totalRisks.to_f ).round(3)
	      value1 = (acotado.to_f * c1).round(3)
	      # Valor2: # veces que un proceso de Cobit se repite en los riesgos con mayor peso, se acota para que de un valor de 0-5, 0 = no se repite en los riesgos con mayor peso, 5 = se repite siempre
	      reps = repetidos.select{|r| r == proc.id_fuente}
	      # Para acotar el valor de 0-5, se usa una regla de 3, acotado = (5 * repeticiones)/totalRepeticiones
	      acotado = ( (5.0 * reps.size.to_f) / repetidos.size.to_f).round(3)
	      value2 = (acotado.to_f * c2).round(3)
	      # Valor:
	      value = ((value1 + value2) * pesoRiesgos.to_f).round(3)
	      valueString = proc.id.to_s << '|' << value.to_s
	      valores.push(valueString)
	    end
	    
	    return valores

	  end

	  # Obtiene la importancia de los objetivos:
	  def get_goal_importance(escenario)
	    esc = escenario
	    escObj = esc.goal_escenario # Escenario de evaluacion de objetivos
	    procesos = ItProcess.all.order(id: :asc)
	    pesoObjetivos = (esc.goalsWeight.to_f / 100.to_f).round(3)
	    # Por cada proceso calcula un valor de la siguiente manera:
	    valores = []

	    # 1. Calcula los valores de P y S, para cada tipo de objetivo, y cada dimension: NO SE CALCULA, SON FIJOS

	    # P: 5
	    # S: 2,5
	    # N: 0

	    pGlobal = 1.0
	    sGlobal = 0.5
	    nGlobal = 0.0

	    # ========================= Objetivos de TI =============================
	    objsTI = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, IT_GOAL) # Objetivos de TI

	    pFinIT = pGlobal # Valor P - Objetivo de TI - Dimension: Financial
	    sFinIT = sGlobal  # Valor S - Objetivo de TI - Dimension: Financial

	    pCusIT = pGlobal  # Valor P - Objetivo de TI - Dimension: Customer
	    sCusIT = sGlobal  # Valor S - Objetivo de TI - Dimension: Customer

	    pIntIT = pGlobal  # Valor P - Objetivo de TI - Dimension: Internal
	    sIntIT = sGlobal  # Valor S - Objetivo de TI - Dimension: Internal

	    pLyGIT = pGlobal  # Valor P - Objetivo de TI - Dimension: Learning and Growth
	    sLyGIT = sGlobal  # Valor S - Objetivo de TI - Dimension: Learning and Growth

	    # ========================= Objetivos de Negocio =========================
	    objsBu = Goal.where("goal_type = ? AND scope = ?", GENERIC_TYPE, B_GOAL) # Objetivos de Negocio

	    pFinBu = pGlobal # Valor P - Objetivo de Negocio - Dimension: Financial
	    sFinBu = sGlobal  # Valor S - Objetivo de Negocio - Dimension: Financial

	    pCusBu = pGlobal # Valor P - Objetivo de Negocio - Dimension: Customer
	    sCusBu = sGlobal  # Valor S - Objetivo de Negocio - Dimension: Customer

	    pIntBu = pGlobal  # Valor P - Objetivo de Negocio - Dimension: Internal
	    sIntBu = sGlobal  # Valor S - Objetivo de Negocio - Dimension: Internal

	    pLyGBu = pGlobal  # Valor P - Objetivo de Negocio - Dimension: Learning and Growth
	    sLyGBu = sGlobal  # Valor S - Objetivo de Negocio - Dimension: Learning and Growth

	    # Constantes: FINANCIAL, CUSTOMER, INTERNAL, L_AND_G 

	    # 2. Por cada objetivo de TI, calcula su nivel de importancia, siguiendo el siguiente proceso:
	    # Cruza cada objetivo de TI, con cada uno de los objetivos de negocio, y realiza la siguiente operación:
	    # Importancia del objetivo de negocio = A (Definida en la evaluación del escenario de objetivos)
	    # Valor de P/S de dicho objetivo de negocio = M (Calculado anteriormente)
	    # Por cada objetivo de TI, calcula su cruce A*M, y suma el total, dicho valor debe ser promediado:
	    
	    calsObj = escObj.goal_califications # Calificaciones de ambos tipos de objetivos
	    nivelesObjTI = [] # Arreglo con los valores parametrizados del nivel de importancia por objetivo de TI
	    calsTI = calsObj.select{|c| c.goal.scope == IT_GOAL} # Calificaciones para ese escenario, de los objetivos de TI
	    calsBu = calsObj.select{|c| c.goal.scope == B_GOAL} # Calificaciones para ese escenario, de los objetivos de negocio

	    negocioITMatrix = BusinessGoalItMatrix.all # Carga la matriz de relaciones: Objetivos de Negocio VS Objetivos de TI
	    procesoITMatrix = ItGoalsProcessesMatrix.all # Carga la matriz de relaciones: Objetivos de TI VS Procesos 

	    objsTI.each do |objTI|
	      value = 0 # En este valor se irá sumando cada valor del cruce A*M para cada objetivo de TI

	      objsBu.each do |objBu|
	        # 2.1 Obtiene la importancia del objetivo de negocio, definida en el escenario
	        cal = calsBu.select{|c| c.goal.id == objBu.id}.first
	        # Si no se calificó dicho objetivo, queda en 0:
	        if cal.nil?
	          importancia = 0
	        else
	          importancia = cal.importance
	        end

	        # 2.2 Obtiene el valor (P/S), del cruce recien definido:
	        valuePS = negocioITMatrix.select{|m| m.it_goal_id == objTI.id && m.business_goal_id == objBu.id}.first.value
	        # Asigna el valor, según la dimension del objetivo de negocio:
	        case objBu.dimension
	        when FINANCIAL
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pFinBu
	          when 'S'
	            valuePS  = sFinBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when CUSTOMER
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pCusBu
	          when 'S'
	            valuePS  = sCusBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when INTERNAL
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pIntBu
	          when 'S'
	            valuePS  = sIntBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when L_AND_G
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pLyGBu
	          when 'S'
	            valuePS  = sLyGBu
	          when 'N'
	            valuePS  = nGlobal
	          end
	        end 

	        # 2.3 Calcula el valor A*M, para ese cruce de ese objetivo de negocio:
	        # importancia = A, valuePS = M
	        value+= (importancia.to_f * valuePS.to_f)
	      end

	      # Como el maximo valor que puede tomar value es 50, pero al promediar y que el maximo sea 5 debe ser 85, se suma 35 deliberadamente:
	      value = value + 35

	      # 2.4 Al llegar a este punto, ya tiene el total, simplemente lo agrega al arreglo, en forma de string: ID_Objetivo|Valor Total
	      temp = objTI.id.to_s << '|' << value.round(3).to_s
	      valores.push(temp)
	    end

	    # 3. Promedia el valor total de cada objetivo de TI, sobre el total de objetivos de negocio que fue los que se cruzaron:
	    valoresPara = []

	    valores.each do |v|
	      idObj = v.split('|')[0].to_s
	      val = v.split('|')[1].to_f
	      valAvg = (val / objsBu.size.to_f).round(3)
	      newVal = idObj.to_s << '|' << valAvg.to_s
	      valoresPara.push(newVal)
	    end



	    # 4. Por cada proceso, calcula su nivel de importancia, siguiendo el siguiente proceso:
	    # Cruza cada proceso, con cada uno de los objetivos de TI, y realiza la siguiente operación:
	    # Importancia del objetivo de TI = I (Definida en la evaluación del escenario de objetivos)
	    # Valor de P/S de dicho objetivo de TI = N (Calculado anteriormente en el punto 1)
	    # Nivel de importancia del objetivo de TI, promediado en el punto anterior = Z
	    # Por cada proceso, calcula su cruce I*N*Z/5, y suma el total:
	    valoresFinal = [] # Arreglo que guarda strings con el formato: ID_Proceso|Valor Final

	    procesos.each do |pr|
	      value = 0

	      objsTI.each do |objTI|
	        # 4.1 Obtiene la importancia del objetivo de TI, definida en el escenario
	        cal = calsTI.select{|c| c.goal.id == objTI.id}.first
	        # Si no se calificó dicho objetivo, queda en 0:
	        if cal.nil?
	          importancia = 0
	        else
	          importancia = cal.importance
	        end

	        # 4.2 Obtiene el valor (P/S), del cruce recien definido:
	        valuePS = procesoITMatrix.select{|m| m.it_goal_id == objTI.id && m.process_id == pr.id}.first.value
	        # Asigna el valor, según la dimension del objetivo de negocio:
	        case objTI.dimension
	        when FINANCIAL
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pFinIT
	          when 'S'
	            valuePS  = sFinIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when CUSTOMER
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pCusIT
	          when 'S'
	            valuePS  = sCusIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when INTERNAL
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pIntIT
	          when 'S'
	            valuePS  = sIntIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        when L_AND_G
	          # Asigna su valor, según si es P,S o N
	          case valuePS
	          when 'P'
	            valuePS  = pLyGIT
	          when 'S'
	            valuePS  = sLyGIT
	          when 'N'
	            valuePS  = nGlobal
	          end
	        end

	        # 4.3 Obtiene el valor promediado para ese objetivo de TI:
	        valuePara = 0.0
	        valoresPara.each do |v|
	          idObj = v.split('|')[0].to_i
	          if idObj == objTI.id
	            valuePara = v.split('|')[1].to_f
	            break
	          end
	        end



	        # 4.4 Calcula el valor I*N*Z, para ese cruce de ese proceso:
	        # importancia = I, valuePS = N, valuePara = Z
	        valueTemp =  (importancia.to_f * valuePS.to_f * valuePara.to_f).round(3)
	        value+= valueTemp
	      end  
	      
	      # Como el maximo valor de la sumatoria I*N*Z es 184,54, a partir de ahi realiza el calculo para acotar los valores de 0-5
	      value = ((value.round(3) * 5.0) / 184.54).round(3)
	      value = value * pesoObjetivos.to_f
	      # 4.5 Al llegar a este punto, ya tiene el total, simplemente lo agrega al arreglo, en forma de string: ID_Proceso|Valor Total
	      temp = pr.id.to_s << '|' << value.round(3).to_s
	      valoresFinal.push(temp)

	    end

	    return valoresFinal
	  end

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


	  # Obtiene todos los resultados de la priorizacion:
	  def get_priorization_stats(escenario)
	    esc = escenario
	    riskImportance = get_risk_importance(esc)
	    goalImportance = get_goal_importance(esc)
	    procesos = ItProcess.all

	    stats = []
	    # Primera posicion, el nombre del escenario:
	    # stats[0] = esc.name << '|0|0|0|9999'
	    # Segunda posicion, el peso de los riesgos:
	    # stats[1] = esc.risksWeight.to_s << '|0|0|0|9998'
	    # Tercera posicion, el peso de los objetivos:
	    # stats[2] = esc.goalsWeight.to_s << '|0|0|0|9997'
	    
	    # Las siguientes posiciones son strings con el formato:
	    # ID_Proceso|importancia_riesgos|importancia_objetivos|importancia_total
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

	    # Elimina el ultimo separador:
	    resp = resp[0, resp.length - 4]

	    return resp

	  end
	  # ------------











  end
end
