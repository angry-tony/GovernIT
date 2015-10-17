class CreateEscenariosRiskCalifications < ActiveRecord::Migration
  def change
    create_table :escenarios_risk_califications do |t|
    	t.integer :risk_id
    	t.integer :valor
    	t.integer :cantidad
    	t.string :risk_type
    	t.text :evidence
    	t.integer :risk_escenario_id
    end
  end
end
