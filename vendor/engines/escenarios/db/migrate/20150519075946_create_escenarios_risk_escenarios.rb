class CreateEscenariosRiskEscenarios < ActiveRecord::Migration
  def change
    create_table :escenarios_risk_escenarios do |t|
    	t.string :name
    	t.integer :governance_structure_id
    	t.integer :enterprise_id
    	t.text :consolidate_info
    end
  end
end
