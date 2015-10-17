# This migration comes from escenarios (originally 20150519075805)
class CreateEscenariosGoals < ActiveRecord::Migration
  def change
    create_table :escenarios_goals do |t|
    	t.text :description
    	t.string :goal_type
    	t.string :scope
    	t.string :dimension
    	t.integer :parent_id
    	t.integer :enterprise_id
    end
  end
end
