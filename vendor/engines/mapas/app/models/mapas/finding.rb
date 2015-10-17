module Mapas
  class Finding < ActiveRecord::Base
  	belongs_to :decision_map, class_name: "DecisionMap", foreign_key: "decision_map_id"
	belongs_to :governance_decision, class_name: "GovernanceDecision", foreign_key: "governance_decision_id"
  end
end
