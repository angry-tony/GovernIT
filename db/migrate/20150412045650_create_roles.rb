class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :name
    	t.string :description
    end

    # Crea la tabla puente de la asociacion n-n
    create_table :roles_users, id: false do |t|
      t.belongs_to :role
      t.belongs_to :user
    end

  end
end