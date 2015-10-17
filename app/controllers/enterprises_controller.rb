#encoding: utf-8

class EnterprisesController < ApplicationController
  def new
    begin
      authorize! :create, Enterprise
    rescue
      raise CanCan::AccessDenied.new("No tiene autorización para crear empresas")
    end
  end
  # ==========

  def edit
    @empresa = view_context.getMyEnterprise
    @empresas = Enterprise.all

    begin
      authorize! :update, Enterprise
    rescue
      raise CanCan::AccessDenied.new("No tiene autorización para editar empresas")
    end

  end
  # ===========

  def update
    empresa = Enterprise.find(params[:idEmpresa].to_i)
    # Actualiza todo lo que encuentre:
    empresa.name = params[:nombre]
    empresa.description = params[:desc]
    if !params[:logo].nil?
      empresa.logo = params[:logo]
    end
    

    if empresa.save
      flash[:notice] = 'La empresa ' << empresa.name << ' fue actualizada con éxito!'
    else
      flash[:alert] = 'ERROR: Actualizando la empresa ' << empresa.name
    end

    # Redirige al inicio!
    redirect_to root_url
  end


  def resultado
  	nombre = params[:nombre]
  	descripcion = params[:desc]
  	@error = ''

  	if nombre == nil or nombre.empty?
  		@error = 'Debe definir un nombre'
  	end

    if @error.empty?
      # Crea la empresa
  	  @empresa = Enterprise.create(name: nombre, description: descripcion, logo: params[:logo])
    end
  end

  # Obtiene la informacion de la empresa via ajax:
  def get_enterprise
    empresa = Enterprise.find(params[:idEmpresa].to_i)

    respond_to do |format|
        format.json {render json: empresa}
    end 
    
  end








end
