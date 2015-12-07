#encoding: utf-8

class ConfigController < ApplicationController

  def riskmap
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
          @niveles = @riskmap.riskmap.split('|')
        end
      end

    else
      redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
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
        config.save
      else     
        if config.update(riskmap: string)
        # Actualizo bien, no hace nada
        else
        # No actualizo, informa:
        @error = 'ERROR: Updating the configuration record.'
        end    
      end

    else # Sesión invalida
      redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
    end

  end

end
