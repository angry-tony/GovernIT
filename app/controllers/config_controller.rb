#encoding: utf-8

class ConfigController < ApplicationController

  def riskmap
    begin
      authorize! :riskmap, Configuracion
    rescue
      raise CanCan::AccessDenied.new("No tiene autorización para acceder al menú de configuración")
    end

    # La empresa se carga, si la sesión está definida:
    emp = view_context.getMyEnterprise

    if !emp.nil?
      @empresa = emp
      @riskmap = @empresa.configuracion

      # Si no encuentra la configuracion, la envía vacía
      if @riskmap.nil?
        # Envía en los niveles, los valores por defecto
        @default = RISK_SCALE  
        @niveles = @default.split('|')      
      else
        # Si no encuentra la configuración, la envía vacía:
        if @riskmap.riskmap.nil? or @riskmap.riskmap.empty?
          # Envía en los niveles, los valores por defecto
          @default = RISK_SCALE  
          @niveles = @default.split('|')
        else
          begin
            authorize! :read, @riskmap
          rescue
            raise CanCan::AccessDenied.new("No tiene autorización para acceder a la configuración de la empresa: " << @empresa.name)
          end
          @niveles = @riskmap.riskmap.split('|')
        end
      end

    else
      redirect_to root_url, :alert => 'ERROR: Empresa no encontrada. Debe seleccionar una empresa en el menú inicial'
    end
  end

  def resultado
    # La empresa se carga, si la sesión está definida:
    emp = view_context.getMyEnterprise

    if !emp.nil?
      # Configuro la escala de riesgos
      string = params[:niveles]
      config = emp.configuracion
      # Si no encuentra la configuracion, crea una nueva
      if config == nil
        config = Configuracion.new
        config.enterprise_id = emp.id
        config.riskmap = string
        begin
          authorize! :create, config
        rescue
          raise CanCan::AccessDenied.new("No tiene autorización para crear configuraciones de la empresa: " << emp.name)
        end
        config.save
      else     
        begin
          authorize! :update, config
        rescue
          raise CanCan::AccessDenied.new("No tiene autorización para modificar la configuración de la empresa: " << emp.name)
        end

        if config.update(riskmap: string)
        # Actualizo bien, no hace nada
        else
        # No actualizo, informa:
        @error = 'ERROR: No se pudo actualizar el registro'
        end    
      end

    else # Sesión invalida
      redirect_to root_url, :alert => 'ERROR: Empresa no encontrada. Debe seleccionar una empresa en el menú inicial'
    end

  end

end
