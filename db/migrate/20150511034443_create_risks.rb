class CreateRisks < ActiveRecord::Migration
  def change
    create_table :risks do |t|
    	t.text :descripcion
    	t.string :nivel
    	t.integer :riesgo_padre_id
    	t.integer :risk_category_id
    	t.integer :enterprise_id
    end
  end
end
