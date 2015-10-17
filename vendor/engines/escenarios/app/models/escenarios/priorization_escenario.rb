module Escenarios
  class PriorizationEscenario < ActiveRecord::Base
  	belongs_to :enterprise, class_name: "Enterprise",
	            foreign_key: "enterprise_id"
	belongs_to :risk_escenario, inverse_of: :priorization_escenarios,
	            foreign_key: "risk_escenario_id"
	belongs_to :goal_escenario, inverse_of: :priorization_escenarios,
	            foreign_key: "goal_escenario_id"
  end
end
