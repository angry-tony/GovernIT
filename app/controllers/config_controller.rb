#encoding: utf-8

class ConfigController < ApplicationController

  def riskmap
    # ES: La empresa se carga, si la sesión está definida:
    # EN: The enterprise is loaded, if the session is defined:
    emp = view_context.getMyEnterprise

    if !emp.nil?
      @empresa = emp
      @riskmap = @empresa.configuracion

      # ES: Si no encuentra la configuracion, la envía vacía
      # EN: If the configuration is not founded, send it empty
      if @riskmap.nil?
        # ES: Envía en los niveles, los valores por defecto
        # EN: Send in the levels, the default values
        @default = RISK_SCALE  
        @niveles = @default.split('|')      
      else
        # ES: Si no encuentra la configuración, la envía vacía:
        # EN: If the configuration is not founded, send it empty
        if @riskmap.riskmap.nil? or @riskmap.riskmap.empty?
          # ES: Envía en los niveles, los valores por defecto
          # EN: Send in the levels, the default values
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
    # ES: La empresa se carga, si la sesión está definida:
    # EN: The enterprise is loaded, if the session is defined:
    emp = view_context.getMyEnterprise

    if !emp.nil?
      # ES: Configuro la escala de riesgos
      # EN: The risk scale is configured
      string = params[:niveles]
      config = emp.configuracion
      # ES: Si no encuentra la configuracion, crea una nueva
      # EN: If the configuration is not founded, create a new one
      if config == nil
        config = Configuracion.new
        config.enterprise_id = emp.id
        config.riskmap = string
        config.save
      else     
        if config.update(riskmap: string)
        # ES: Actualizo bien, no hace nada
        # EN: Correct update, do nothing
        else
        # ES: No actualizo, informa:
        # EN: Problem updating, inform:
        @error = 'ERROR: Updating the configuration record.'
        end    
      end

    else # ES: Sesión invalida - EN: Invalid session
      redirect_to root_url, :alert => 'ERROR: Enterprise not found. Select one from the initial menu.'
    end

  end

end
