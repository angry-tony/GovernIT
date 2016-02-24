module Mapas
  module GovernanceHelper


	# ES: Metodo recursivo que da la cantidad de decisiones hijas de una decision:
	# EN: Recursive method that returns the total number of decision-sons given a decision:
	def recursiveDarHijos(decision, hijos)
		if decision.hijas.size ==  0
			return [] 
		else
			decision.hijas.each do |d|
				hijos.push(d.id)
				# ES: Contabiliza el numero de hijos de cada una y al final se suma a si mismo
				# EN: Count the number of sons of each one and in the end add it itself
				recursiveDarHijos(d, hijos)
			end

			return hijos
		end
	end
	# -----------

	# ES: Metodo que da los registros de detalle en los mapas de decision de un grupo de decisiones:
	# EN: Method that returns the details in the decision maps of a group of decisions
	def darDetalles(decisiones)
		detalles = MapDetail.where(governance_decision_id: decisiones).map {|d| d.id }
		return detalles
	end
	# ---------

	# ES: Metodo que da los registros de hallazgos en los mapas de decision de un grupo de decisiones:
	# EN: Method that returns the findings in the decision maps of a group of decisions
	def darHallazgos(decisiones)
		hallazgos = Finding.where(governance_decision_id: decisiones).map {|f| f.id }
		return hallazgos
	end
	# -----------

	# ES: Metodo que traduce la visualizacion de las dimensiones (desde el español):
	# EN: Method that translates the visualization of the dimensions (Spanish-English):
	def translateDimension(dimension)
		case dimension
		when DIM_DEC_1 then I18n.t 'EM_dimension1'
		when DIM_DEC_2 then I18n.t 'EM_dimension2'
		when DIM_DEC_3 then I18n.t 'EM_dimension3'
		when DIM_DEC_4 then I18n.t 'EM_dimension4'
		when DIM_DEC_5 then I18n.t 'EM_dimension5'
		when DIM_DEC_6 then I18n.t 'EM_dimension6'			
		end
	end
	# ------- translateDimension

	# ES: Metodo que traduce la visualizacion de las columnas de un mapa de delgacion de responsabilidades (desde el español):
	# EN: Method that translates the visualization of the columns of a responsibilities delegation map (Spanish-English):
	def translateDelegResp(resp)
		case resp
		when DELEG_RESP_1 then I18n.t 'EM_delegResp1'
		when DELEG_RESP_2 then I18n.t 'EM_delegResp2'
		when DELEG_RESP_3 then I18n.t 'EM_delegResp3'
		when DELEG_RESP_4 then I18n.t 'EM_delegResp4'
		when DELEG_RESP_5 then I18n.t 'EM_delegResp5'
		end
	end
	# ------- translateDelegResp

	# ES: Metodo que traduce la visualizacion de las dimensiones (hacia el español):
	# EN: Method that translates the visualization of the dimensions (English-Spanish):
	def translateDimensionToES(dimension)
		dim1 = I18n.t 'EM_dimension1'
		dim2 = I18n.t 'EM_dimension2'
		dim3 = I18n.t 'EM_dimension3'
		dim4 = I18n.t 'EM_dimension4'
		dim5 = I18n.t 'EM_dimension5'
		dim6 = I18n.t 'EM_dimension6'

		case dimension
		when dim1 then DIM_DEC_1
		when dim2 then DIM_DEC_2
		when dim3 then DIM_DEC_3
		when dim4 then DIM_DEC_4
		when dim5 then DIM_DEC_5
		when dim6 then DIM_DEC_6
		end
	end
	# ------- translateDimensionToES
	
	




  end
end
