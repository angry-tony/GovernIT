module Escenarios
  class GoalEscenario < ActiveRecord::Base
  	has_many :priorization_escenarios, inverse_of: :goal_escenario
	has_many :goal_califications, inverse_of: :goal_escenario
	belongs_to :governance_structure, class_name: "GovernanceStructure",
	            foreign_key: "governance_structure_id"
	belongs_to :enterprise, foreign_key: "enterprise_id"
  end
end
