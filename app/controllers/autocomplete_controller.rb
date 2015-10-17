class AutocompleteController < ApplicationController
	def responsabilities
	  	busq = '%' << params[:term].downcase << '%'  # Todo en minúscula
	  	resps = GovernanceResponsability.where('lower(name) LIKE ?', busq).map { |r| r.id.to_s + ' - ' + r.name }
	  	if resps.size == 0
	  	  r = GovernanceResponsability.new
	      r.name = params[:term]
	      resps << r
	      if I18n.default_locale.to_s.eql?("en")
	      	resps = resps.map { |r| '(Add) - ' + r.name }
	      else
	      	resps = resps.map { |r| '(Agregar) - ' + r.name }
	      end
	      
	  	end
	  	render json: resps
	end
	# -------------
end
