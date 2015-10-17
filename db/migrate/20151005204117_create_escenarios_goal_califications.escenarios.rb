# This migration comes from escenarios (originally 20150519075817)
class CreateEscenariosGoalCalifications < ActiveRecord::Migration
  def change
    create_table :escenarios_goal_califications do |t|
    	t.integer :goal_id
    	t.integer :importance
    	t.integer :performance
    	t.integer :goal_escenario_id
    end
  end
end
