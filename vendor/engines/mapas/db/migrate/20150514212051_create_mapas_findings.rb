class CreateMapasFindings < ActiveRecord::Migration
  def change
    create_table :mapas_findings do |t|
    	t.text :description
    	t.string :parsed_risks
    	t.text :proposed_updates
    	t.integer :decision_map_id
    	t.integer :governance_decision_id
    end
  end
end
