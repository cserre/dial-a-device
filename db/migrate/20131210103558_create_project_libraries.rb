class CreateProjectLibraries < ActiveRecord::Migration
  def change
    create_table :project_libraries do |t|
      t.integer :project_id
      t.integer :library_id

      t.timestamps
    end
  end
end
