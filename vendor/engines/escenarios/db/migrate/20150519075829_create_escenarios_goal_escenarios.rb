class CreateEscenariosGoalEscenarios < ActiveRecord::Migration
  def change
    create_table :escenarios_goal_escenarios do |t|
    	t.string :name
    	t.integer :governance_structure_id
    	t.integer :enterprise_id
    end
  end
end
