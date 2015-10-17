class CreateConfiguracions < ActiveRecord::Migration
  def change
    create_table :configuracions do |t|
    	t.string :riskmap
    	t.integer :enterprise_id
    end
  end
end
