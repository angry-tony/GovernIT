class CreateEscenariosPriorizationEscenarios < ActiveRecord::Migration
  def change
    create_table :escenarios_priorization_escenarios do |t|
    	t.string :name
    	t.integer :risksWeight
    	t.integer :goalsWeight
    	t.integer :enterprise_id
    	t.integer :risk_escenario_id
    	t.integer :goal_escenario_id
    	t.date :fecha_ejecucion
    	t.text :stats
    end
  end
end
