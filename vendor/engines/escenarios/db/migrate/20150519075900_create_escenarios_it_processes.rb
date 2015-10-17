class CreateEscenariosItProcesses < ActiveRecord::Migration
  def change
    create_table :escenarios_it_processes do |t|
    	t.string :description
    	t.string :domain
    	t.string :fuente
    	t.string :id_fuente
    end
  end
end
