class AddUserToProjectMolecule < ActiveRecord::Migration
  def change
    add_column :project_molecules, :user_id, :integer
  end
end
