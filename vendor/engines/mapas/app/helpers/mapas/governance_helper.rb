# ==========================================================================
# GovernIT: A Software for Creating and Controlling IT Governance Models

# Copyright (C) 2015  Oscar González Rojas - Sebastián Lesmes Alvarado

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/

# Authors' contact information (e-mail):
# Oscar González Rojas: o-gonza1@uniandes.edu.co
# Sebastián Lesmes Alvarado: s.lesmes798@uniandes.edu.co

# ==========================================================================

module Mapas
  module GovernanceHelper


	# Metodo recursivo que da la cantidad de decisiones hijas de una decision:
	def recursiveDarHijos(decision, hijos)
		if decision.hijas.size ==  0
			return [] 
		else
			decision.hijas.each do |d|
				hijos.push(d.id)
				# Contabiliza el numero de hijos de cada una y al final se suma a si mismo
				recursiveDarHijos(d, hijos)
			end

			return hijos
		end
	end
	# -----------

	# Metodo que da los registros de detalle en los mapas de decision de un grupo de decisiones:
	def darDetalles(decisiones)
		detalles = MapDetail.where(governance_decision_id: decisiones).map {|d| d.id }
		return detalles
	end
	# ---------

	# Metodo que da los registros de hallazgos en los mapas de decision de un grupo de decisiones:
	def darHallazgos(decisiones)
		hallazgos = Finding.where(governance_decision_id: decisiones).map {|f| f.id }
		return hallazgos
	end
	# -----------

	# Metodo que traduce la visualizacion de las dimensiones:
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

	# Metodo que traduce la visualizacion de las columnas de un mapa de delgacion de responsabilidades:
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
	
	




  end
end
