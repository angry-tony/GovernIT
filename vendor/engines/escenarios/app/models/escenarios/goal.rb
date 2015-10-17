module Escenarios
  class Goal < ActiveRecord::Base
  	has_one :parent, class_name: "Goal",
	                              foreign_key: "parent_id"

	belongs_to :goal, class_name: "Goal"
	has_many :goal_califications, inverse_of: :goal
  end
end
