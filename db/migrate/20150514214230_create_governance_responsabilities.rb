class CreateGovernanceResponsabilities < ActiveRecord::Migration
  def change
    create_table :governance_responsabilities do |t|
    	t.string :name
    end

    create_table :governance_responsabilities_structures, id: false do |t|
    	t.belongs_to :governance_responsability
    	t.belongs_to :governance_structure
    end
    
  end
end
