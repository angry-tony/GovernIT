module Mapas
  class GovernanceDecision < ActiveRecord::Base
  	has_many :hijas, class_name: "GovernanceDecision",
	                              foreign_key: "parent_id", dependent: :destroy
	                              
	belongs_to :padre, class_name: "GovernanceDecision"
	belongs_to :enterprise, class_name: "Enterprise", foreign_key: "enterprise_id"
	has_many :map_details, class_name: "MapDetail", inverse_of: :governance_decision, dependent: :destroy
	has_many :findings, class_name: "Finding", inverse_of: :governance_decision, dependent: :destroy
  end
end
