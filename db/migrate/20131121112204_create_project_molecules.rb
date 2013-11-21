class CreateProjectMolecules < ActiveRecord::Migration
  def change
    create_table :project_molecules do |t|
      t.integer :project_id
      t.integer :molecule_id

      t.timestamps
    end
  end
end
