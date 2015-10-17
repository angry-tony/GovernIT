# This migration comes from mapas (originally 20150514212041)
class CreateMapasDecisionMaps < ActiveRecord::Migration
  def change
    create_table :mapas_decision_maps do |t|
    	t.string :name
    	t.string :description
    	t.string :map_type
    	t.integer :governance_structure_id
    	t.integer :enterprise_id
    end
  end
end
