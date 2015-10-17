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

require_dependency "mapas/application_controller"

module Mapas
  class AutocompleteController < ApplicationController

	def mechanisms
	    busq = '%' << params[:term].downcase << '%'  # Todo en minúscula
	    resps = ComplementaryMechanism.where('lower(description) LIKE ? AND enterprise_id = ?', busq, params[:idEmp].to_i).map { |m| m.id.to_s + ' - ' + m.description }
	    if resps.size == 0
	      m = ComplementaryMechanism.new
	      m.description = params[:term].capitalize
	      resps << m
	      if I18n.default_locale.to_s.eql?("en")
	      	resps = resps.map { |m| '(Add) - ' + m.description }
	      else
	      	resps = resps.map { |m| '(Agregar) - ' + m.description }
	      end
	    end
	    render json: resps
	end
	# ------------



  end
end
