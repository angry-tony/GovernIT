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

module Escenarios
  module GovernanceHelper

  	include PriorizationHelper

	def generarPriorizacion(riskE, goalE, nameE, wRisk, wGoal, emp)
	  	esc = PriorizationEscenario.new
	  	esc.risk_escenario = riskE
	  	esc.goal_escenario = goalE
	  	esc.name = nameE
	  	esc.risksWeight = wRisk
	  	esc.goalsWeight = wGoal
	  	esc.enterprise = emp

	    # Realiza la priorizacion y guarda el resultado:
	    hoy = (Time.now.year).to_s << '-' << Time.now.month.to_s << '-' << Time.now.mday.to_s
	    esc.fecha_ejecucion = hoy

	    # PRIORIZA:
	    stats = get_priorization_stats(esc)

	    esc.stats = stats


	  	# Renderiza la respuesta según el resultado de la creación:
	  	if esc.save
	  		return true
	  	else
	  		return false
	  	end
	end
	# -------------

  end
end
