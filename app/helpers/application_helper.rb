module ApplicationHelper

	# ES: Metodo que devuelve la empresa (Para los modulos de gobierno y simulacion) de la sesion del usuario, si esta existe:
	# EN: Method that returns the enterprise (for the government and simulation modules) from the user session, if exists:
	def getMyEnterprise
		if session[:empresa].blank?
			emp = nil
		else
			emp = Enterprise.find(session[:empresa].to_i)
		end

		return emp
	end
	# ===========

	# ES: Metodo que devuelve la empresa (Para el modulo de cuantificacion) de la sesion del usuario, si esta existe:
	# EN: Method that returns the enterprise (for the cuantification module) from the user session, if exists:
	def getMyQuantEnterprise
		if session[:quant_empresa].blank?
			# ES: Si no se ha seleccionado nada, devuelve la primer empresa que encuentre
			# EN: If there is no selection, returns the first enterprise that it founds:
			emp = Cuantificacion::CuantificadorImpacto.all.first
		else
			emp = Cuantificacion::CuantificadorImpacto.find(session[:quant_empresa].to_i)
		end

		return emp
	end
	# ===========





end
