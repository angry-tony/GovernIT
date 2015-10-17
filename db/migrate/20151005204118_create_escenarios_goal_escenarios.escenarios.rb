# This migration comes from escenarios (originally 20150519075829)
class CreateEscenariosGoalEscenarios < ActiveRecord::Migration
  def change
    create_table :escenarios_goal_escenarios do |t|
    	t.string :name
    	t.integer :governance_structure_id
    	t.integer :enterprise_id
    end
  end
end
