module Escenarios
  class GoalCalification < ActiveRecord::Base
  	belongs_to :goal_escenario, inverse_of: :goal_califications,
	            foreign_key: "goal_escenario_id"

	belongs_to :goal, inverse_of: :goal_califications, foreign_key: "goal_id"
  end
end
