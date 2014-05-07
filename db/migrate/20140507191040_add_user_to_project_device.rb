class AddUserToProjectDevice < ActiveRecord::Migration
  def change
    add_column :project_devices, :user_id, :integer
  end
end
