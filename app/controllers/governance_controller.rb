#encoding: utf-8

class GovernanceController < ApplicationController

	def structures
		@empresa = view_context.getMyEnterprise		
		if !@empresa.nil?
		    @estructuras = GovernanceStructure.where("enterprise_id = ?", @empresa.id).order(id: :asc)
		    @padres = GovernanceStructure.where("enterprise_id = ? AND parent_id IS NULL", @empresa.id).order(id: :asc)
		    @perfiles = [PERFIL_EST_1,PERFIL_EST_2,PERFIL_EST_3,PERFIL_EST_4,PERFIL_EST_5,PERFIL_EST_6,PERFIL_EST_7]
		else
			redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
		end
	end
	# -----------------

	def add_structure
		@empresa = view_context.getMyEnterprise
		# Resultados de la creación de estructuras de gobierno:
		name = params[:name]
		tipo = params[:tipo]
		funcs = params[:funcs]
		padre = params[:id_padre]
		type = params[:type]
		perfil = params[:perfil]

		estG = GovernanceStructure.new
		estG.name = name
		estG.structure_type = tipo
		resps = GovernanceResponsability.where(id: funcs)
		estG.governance_responsabilities = resps
		estG.enterprise_id = @empresa.id
		estG.global_type = type
		estG.profile = perfil
		if padre.to_i == 0
			estG.parent = nil
		else
			estG.parent = GovernanceStructure.find(padre.to_i)
		end

		respond_to do |format|
			if estG.save
				# Todo OK
				format.json {render json: estG}
			else
				# No se pudo guardar
				format.json {render json: 'ERROR'}
			end
			
        end			
	end
	# --------------

	def add_responsability
		name = params[:name]
		gr = GovernanceResponsability.new
		gr.name = name

        respond_to do |format|
        	if gr.save # OK
        		format.json {render json: gr}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
	end
	# --------------

	def get_structure
		est = GovernanceStructure.find(params[:id])

		respond_to do |format|
        	if !est.nil? # OK
        		format.json {render json: est}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
		
	end
	# ------------


	# Obtiene la informacion de las funciones de una estructura, y sus conflictos (Via AJAX):
	def get_functions
		emp = view_context.getMyEnterprise
		est = GovernanceStructure.find(params[:idEst].to_i)
		funcs = est.governance_responsabilities

		# Para conocer los conflictos, por cada funcion saca sus responsables, depura y compara:
		conflictos = []
		funcs.each do |f|
			ests = f.governance_structures
			# Depura de las estructuras asociadas, para dejar sólo las de la misma empresa.
			depuradas = []

			ests.each do |est|
				# Recorre todas las estructuras, si son de la misma empresa, la va agregando:
				if est.enterprise_id == emp.id
					depuradas.push(est)
				end
			end

			# Re-asigna:
			ests = depuradas

			if ests.size > 1
				# Tiene este responsable, y al menos otro adicional
				otros = ests.select{|o| o.id != est.id}
				temp = f.name
				otros.each do |o|
					temp+= '|' + o.name
				end

				if temp.include? '|'
					conflictos.push(temp)
				end
				# String del tipo: Nombre_funcion|estructura conflictiva1|estructura conflictiva2.....
			end
		end

		funcs = est.governance_responsabilities.map {|f| f.name}

		# Si hay conflictos, los envia en el mismo arreglo, pero con un elemento de separación:
		if conflictos.size > 0
			funcs.push("#$%&/()=") # Separacion
			conflictos.each do |c|
				funcs.push(c)
			end
		end

		respond_to do |format|
			format.json {render json: funcs}
		end
	end
	# ---------

	def update_structure
		est = GovernanceStructure.find(params[:id].to_i)
		n_name = params[:name]
		n_tipo = params[:tipo]
		n_funcs = params[:funcs]
		n_perfil = params[:perfil]
		resps = GovernanceResponsability.where(id: n_funcs)
		# Actualiza los textos normales:
		est.name = n_name
		est.structure_type = n_tipo
		est.profile = n_perfil
		est.governance_responsabilities = resps

		respond_to do |format|
        	if est.save # OK
        		format.json {render json: est}
         	else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end			
	end
	# ----------------

	def get_responsabilities
		est = GovernanceStructure.find(params[:id])
		respond_to do |format|
        	if !est.nil? # OK
        		format.json {render json: est.governance_responsabilities}
      		else # ERROR
      			format.json {render json: "ERROR"}
      		end
    	end	
		
	end
	# -------------------


end
