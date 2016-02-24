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
		# ES: Resultados de la creación de estructuras de gobierno:
		# EN: Results of the governance structure creation:
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
				# ES: Todo OK - EN: All OK
				format.json {render json: estG}
			else
				# ES: No se pudo guardar - EN: Unable to save
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


	# ES: Obtiene la informacion de las funciones de una estructura, y sus conflictos (Via AJAX):
	# EN: Get the information of the governance structure's responsibilities and their conflicts (through AJAX):
	def get_functions
		emp = view_context.getMyEnterprise
		est = GovernanceStructure.find(params[:idEst].to_i)
		funcs = est.governance_responsabilities

		# ES: Para conocer los conflictos, por cada funcion saca sus responsables, depura y compara:
		# EN: To know the conflicts, for each responsibility obtain its responsibles, debug and compare:
		conflictos = []
		funcs.each do |f|
			ests = f.governance_structures
			# ES: Depura de las estructuras asociadas, para dejar sólo las de la misma empresa.
			# EN: Debug the related structures, to get only the ones from the same enterprise
			depuradas = []

			ests.each do |est|
				# ES: Recorre todas las estructuras, si son de la misma empresa, la va agregando:
				# EN: Through all structures, add the ones from the same enterprise:
				if est.enterprise_id == emp.id
					depuradas.push(est)
				end
			end

			# ES: Re-asigna:
			# EN: Re-assing:
			ests = depuradas

			if ests.size > 1
				# ES: Tiene este responsable, y al menos otro adicional
				# EN: Have this responsible, and at least another one
				otros = ests.select{|o| o.id != est.id}
				temp = f.name
				otros.each do |o|
					temp+= '|' + o.name
				end

				if temp.include? '|'
					conflictos.push(temp)
				end
				# ES: String del tipo: Nombre_funcion|estructura conflictiva1|estructura conflictiva2.....
				# EN: String with the format: responsibility_name|conflicted structure 1|conflicted structure 2....
			end
		end

		funcs = est.governance_responsabilities.map {|f| f.name}

		# ES: Si hay conflictos, los envia en el mismo arreglo, pero con un elemento de separación:
		# EN: If there is at least 1 conflict, send them in the same array, but with a separator:
		if conflictos.size > 0
			funcs.push("#$%&/()=") # ES: Separacion - EN: Separator
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
		# ES: Actualiza los textos normales:
		# EN: Update the regular texts:
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
