# This migration comes from mapas (originally 20150514212143)
class CreateMapasMapDetails < ActiveRecord::Migration
  def change
    create_table :mapas_map_details do |t|
    	t.integer :governance_structure_id
    	t.integer :governance_decision_id
    	t.integer :decision_map_id
    	t.integer :decision_archetype_id
    	t.string :responsability_type
    	t.text :complementary_mechanisms
    end
  end
end
