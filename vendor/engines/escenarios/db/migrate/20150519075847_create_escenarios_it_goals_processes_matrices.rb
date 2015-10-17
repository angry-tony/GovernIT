class CreateEscenariosItGoalsProcessesMatrices < ActiveRecord::Migration
  def change
    create_table :escenarios_it_goals_processes_matrices, id: false do |t|
    	t.integer :process_id
    	t.integer :it_goal_id
    	t.string :value
    end
  end
end
