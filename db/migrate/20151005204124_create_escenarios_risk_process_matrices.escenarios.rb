# This migration comes from escenarios (originally 20150519075959)
class CreateEscenariosRiskProcessMatrices < ActiveRecord::Migration
  def change
    create_table :escenarios_risk_process_matrices, id: false do |t|
    	t.integer :risk_category_id
    	t.text :related_processes
    end
  end
end
