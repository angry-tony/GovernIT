module ApplicationHelper

	# Metodo que devuelve la empresa (PAra los modulos de gobierno y simulacion) de la sesion del usuario, si esta existe:
	def getMyEnterprise
		if session[:empresa].blank?
			emp = nil
		else
			emp = Enterprise.find(session[:empresa].to_i)
		end

		return emp
	end
	# ===========

	# Metodo que devuelve la empresa (Para el modulo de cuantificacion) de la sesion del usuario, si esta existe:
	def getMyQuantEnterprise
		if session[:quant_empresa].blank?
			# Si no se ha seleccionado nada, devuelve la primer empresa que encuentre
			emp = Cuantificacion::CuantificadorImpacto.all.first
		else
			emp = Cuantificacion::CuantificadorImpacto.find(session[:quant_empresa].to_i)
		end

		return emp
	end
	# ===========





end
