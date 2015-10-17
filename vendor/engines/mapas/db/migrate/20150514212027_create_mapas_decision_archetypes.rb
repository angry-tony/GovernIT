class CreateMapasDecisionArchetypes < ActiveRecord::Migration
  def change
    create_table :mapas_decision_archetypes do |t|
    	t.string :name
    	t.text :description
    end
  end
end
