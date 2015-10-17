class CreateRiskCategories < ActiveRecord::Migration
  def change
    create_table :risk_categories do |t|
    	t.string :description
    	t.integer :id_padre
    end
  end
end
