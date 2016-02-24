#encoding: utf-8

class EnterprisesController < ApplicationController
  def new
  end
  # ==========

  def edit
    @empresa = view_context.getMyEnterprise
    @empresas = Enterprise.all
  end
  # ===========

  def update
    empresa = Enterprise.find(params[:idEmpresa].to_i)
    # ES: Actualiza todo lo que encuentre:
    # EN: Updates anything founded
    empresa.name = params[:nombre]
    empresa.description = params[:desc]
    if !params[:logo].nil?
      empresa.logo = params[:logo]
    end
    

    if empresa.save
      flash[:notice] = 'The enterprise ' << empresa.name << ' was updated successfully'
    else
      flash[:alert] = 'ERROR: Updating the enterprise ' << empresa.name
    end

    # ES: Redirige al inicio!
    # EN: Redirect to the home!
    redirect_to root_url
  end


  def resultado
  	nombre = params[:nombre]
  	descripcion = params[:desc]
  	@error = ''

  	if nombre == nil or nombre.empty?
  		@error = 'The field name is mandatory'
  	end

    if @error.empty?
      # ES: Crea la empresa
      # EN: Creates the enterprise
  	  @empresa = Enterprise.create(name: nombre, description: descripcion, logo: params[:logo])
    end
  end

  # ES: Obtiene la informacion de la empresa via ajax:
  # EN: Get the enterprise's information through AJAX:
  def get_enterprise
    empresa = Enterprise.find(params[:idEmpresa].to_i)

    respond_to do |format|
        format.json {render json: empresa}
    end 
    
  end








end
