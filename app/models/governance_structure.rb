class GovernanceStructure < ActiveRecord::Base
	has_many :hijas, class_name: "GovernanceStructure",
	                              foreign_key: "parent_id", dependent: :destroy
	                              
	belongs_to :parent, class_name: "GovernanceStructure"
	belongs_to :enterprise, foreign_key: "enterprise_id"

	has_and_belongs_to_many :governance_responsabilities

end
