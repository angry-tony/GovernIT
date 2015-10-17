class AdminController < ApplicationController

  def file_users
  	# A partir de un archivo .csv, realiza la gestión en masa de usuarios
  	file = params[:file]

  	# Contadores de control:
  	skip = 0
  	borrados = 0
  	creados = 0
  	errores = 0
  	empCreadas = 0

  	# Roles del sistema:
  	sysGob = Role.where("name = ?", ROLE_USER_GOV).first
  	sysConfig = Role.where("name = ?", ROLE_USER_CONFIG).first
  	sysSimula = Role.where("name = ?", ROLE_USER_SIMULATION).first
  	sysQuantify = Role.where("name = ?", ROLE_USER_QUANTIFY).first
  	sysEval = Role.where("name = ?", ROLE_EVAL).first
  	sysAdmin = Role.where("name = ?", ROLE_ADMIN).first

  	File.open(file.path, "r") do |f|
	  f.each_line do |line|
	  	if skip == 0
	  		skip = 1
	  		next # La primera linea del archivo la obvia
	  	end

	  	puts line	  	

		ok = true # Variable de control de las operaciones

	  	partes = line.split(";")
	  	# Según la estructura del archivo, las partes son:
	  	# 0 -> Flag de borrado (1 Activo, 0 Inactivo o Borrar)
	  	partes[0] == "1" ? borrar = false : borrar = true
	  	# 1 -> Email
	  	email = partes[1].downcase
	  	# 2 -> Empresa
	  	empresa = partes[2].downcase
	  	# 3 -> Flag para el rol Gobierno de TI (Role_id = 1)
	  	partes[3] == "1" ? rolGob = true : rolGob = false
	  	# 4 -> Flag para el rol Configuracion (Role_id = 2)
	  	partes[4] == "1" ? rolConfig = true : rolConfig = false
	  	# 5 -> Flag para el rol Simulacion (Role_id = 3)
	  	partes[5] == "1" ? rolSimula = true : rolSimula = false
	  	# 6 -> Flag para el rol Cuantificacion (Role_id = 4)
	  	partes[6] == "1" ? rolQuantify = true : rolQuantify = false
	  	# 7 -> Flag para el rol Evaluador (Role_id = 5)
	  	partes[7] == "1" ? rolEval = true : rolEval = false
	  	# 8 -> Flag para el rol Administrador (Role_id = 6)
	  	partes[8] == "1" ? rolAdmin = true : rolAdmin = false

	  	# Define si es una creación, modificación o borrado del usuario:
	  	user = User.where("lower(email) = ?", email).first
	  	emp = Enterprise.where("lower(name) = ?", empresa).first
	  	if !borrar
	  		# Creación o modificación, busca el usuario a ver si existe:
	  		if user.nil?
	  			# No existe, debe crearlo
	  			generated_password = Devise.friendly_token.first(8)
				user = User.new
				user.email = email
				user.password = generated_password
			end

	  		# Crea sus roles, por cada uno valida el flag y lo va agregando a su arreglo
			rolesUser = []
			if rolAdmin
				rolesUser.push(sysAdmin)
			else
				if rolEval
					rolesUser.push(sysEval)
				else
					if rolGob
						rolesUser.push(sysGob)
					end

					if rolConfig
						rolesUser.push(sysConfig)
					end

					if rolSimula
						rolesUser.push(sysSimula)
					end

					if rolQuantify
						rolesUser.push(sysQuantify)
					end
				end				
			end

			

			user.roles = rolesUser
			user.activo = true

			idEmp = nil

			if !rolAdmin && !rolEval
				# Asigna la empresa (La crea si es necesario)
				if emp.nil?
					# Debe crearla (a menos que este asignando un nuevo administrador y no se defina la empresa)
					if !empresa.nil? && empresa.length > 0
		 				emp = Enterprise.new
						emp.name = empresa.capitalize
						#emp.simulator_id = 1 -> Modelo eliminado
						emp.save
						# Crea su portafolio: -> Modelo eliminado
						# newPortf = Portfolio.new
						# newPortf.enterprise_id = emp.id
						# newPortf.save

						empCreadas+= 1
					end
				end

				emp.nil? == true ? idEmp = nil : idEmp = emp.id
			end

			user.enterprise_id = idEmp


			# Despues de las asignaciones agrega el registro:
			begin
				user.save
			rescue Exception => e
				puts "ERROR: " << e.message
				errores+= 1
				ok = false
			end

			if ok
				creados+= 1
			end

	  	else
	  		# Borra el registro
	  		if !user.nil?
	  			user.roles = []
	  			user.save
	  			begin
	  				User.delete(user)
	  			rescue Exception => e
	  				puts "ERROR: " << e.message
	  				errores+= 1
	  				ok = false
	  			end

	  			if ok
	  				borrados+= 1
	  			end
	  		end
	  	end

	  end
	end

	flash[:notice] = "Usuarios creados/modificados: " << creados.to_s << ". Usuarios eliminados: " << borrados.to_s << ". Empresas creadas: " << empCreadas.to_s << "."
	if errores > 0
		flash[:alert] = "Se presentaron " << errores.to_s << " errores procesando el archivo."
	end
  	redirect_to administrar_url
  end

end
