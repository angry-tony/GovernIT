module Mapas
  class DecisionArchetype < ActiveRecord::Base
  	has_many :map_details, class_name: "MapDetail", inverse_of: :decision_archetype, dependent: :destroy
  end
end
