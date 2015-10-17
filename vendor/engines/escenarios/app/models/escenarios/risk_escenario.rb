module Escenarios
  class RiskEscenario < ActiveRecord::Base
  	has_many :califications, class_name: "RiskCalification", inverse_of: :risk_escenario
	has_many :priorization_escenarios, inverse_of: :risk_escenario
	belongs_to :enterprise, foreign_key: "enterprise_id"
	belongs_to :governance_structure, class_name: "GovernanceStructure", foreign_key: "governance_structure_id"
  end
end
