class CreateGovernanceStructures < ActiveRecord::Migration
  def change
    create_table :governance_structures do |t|
    	t.string :name
    	t.string :structure_type
    	t.integer :enterprise_id
    	t.integer :parent_id
    	t.string :global_type
    	t.string :profile
    end
  end
end
