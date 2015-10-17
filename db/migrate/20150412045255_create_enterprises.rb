class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
    	t.string :name
    	t.text :description
    	t.attachment :logo
    end
  end
end
