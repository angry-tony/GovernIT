class CreateMapasGovernanceDecisions < ActiveRecord::Migration
  def change
    create_table :mapas_governance_decisions do |t|
    	t.text :description
    	t.string :dimension
    	t.string :decision_type
    	t.integer :parent_id
    	t.integer :enterprise_id
    end
  end
end
