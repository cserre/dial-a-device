class AddUserToProjectVncrelay < ActiveRecord::Migration
  def change
    add_column :project_vncrelays, :user_id, :integer
  end
end
