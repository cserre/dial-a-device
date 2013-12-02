class CreateProjectBeaglebones < ActiveRecord::Migration
  def change
    create_table :project_beaglebones do |t|
      t.integer :beaglebone_id
      t.integer :project_id

      t.timestamps
    end
  end
end
