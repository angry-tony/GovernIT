module Mapas
  class DecisionMap < ActiveRecord::Base
  	belongs_to :enterprise, class_name: "Enterprise", foreign_key: "enterprise_id"
	belongs_to :governance_structure, class_name: "GovernanceStructure", foreign_key: "governance_structure_id"
	has_many :map_details, class_name: "MapDetail", inverse_of: :decision_map, dependent: :destroy
	has_many :findings, class_name: "Finding", inverse_of: :decision_map, dependent: :destroy
  end
end
