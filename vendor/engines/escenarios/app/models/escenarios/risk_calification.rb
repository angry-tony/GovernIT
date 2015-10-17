module Escenarios
  class RiskCalification < ActiveRecord::Base
  	belongs_to :risk_escenario, inverse_of: :califications,
	            foreign_key: "risk_escenario_id"

	belongs_to :risk, class_name: "Risk", foreign_key: "risk_id"
  end
end
