class AddUserToProjectLibrary < ActiveRecord::Migration
  def change
    add_column :project_libraries, :user_id, :integer
  end
end
