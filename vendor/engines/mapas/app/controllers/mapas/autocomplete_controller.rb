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
