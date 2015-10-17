module Mapas
  class MapDetail < ActiveRecord::Base
  	belongs_to :governance_structure, class_name: "GovernanceStructure", foreign_key: "governance_structure_id"
	belongs_to :governance_decision, class_name: "GovernanceDecision", foreign_key: "governance_decision_id"
	belongs_to :decision_map, class_name: "DecisionMap", foreign_key: "decision_map_id"
	belongs_to :decision_archetype, class_name: "DecisionArchetype", foreign_key: "decision_archetype_id"
  end
end
