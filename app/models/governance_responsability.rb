class GovernanceResponsability < ActiveRecord::Base
	has_and_belongs_to_many :governance_structures
end
