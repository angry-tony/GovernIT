# This migration comes from mapas (originally 20150514212027)
class CreateMapasDecisionArchetypes < ActiveRecord::Migration
  def change
    create_table :mapas_decision_archetypes do |t|
    	t.string :name
    	t.text :description
    end
  end
end
