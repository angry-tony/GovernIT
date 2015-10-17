# This migration comes from mapas (originally 20150514212006)
class CreateMapasComplementaryMechanisms < ActiveRecord::Migration
  def change
    create_table :mapas_complementary_mechanisms do |t|
    	t.string :description
    	t.integer :enterprise_id
    end
  end
end
