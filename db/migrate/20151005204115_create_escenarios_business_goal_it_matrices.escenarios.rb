# This migration comes from escenarios (originally 20150519075752)
class CreateEscenariosBusinessGoalItMatrices < ActiveRecord::Migration
  def change
    create_table :escenarios_business_goal_it_matrices, id: false do |t|
    	t.integer :it_goal_id
    	t.integer :business_goal_id
    	t.string :value
    end
  end
end
