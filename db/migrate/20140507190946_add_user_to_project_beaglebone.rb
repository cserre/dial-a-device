class AddUserToProjectBeaglebone < ActiveRecord::Migration
  def change
    add_column :project_beaglebones, :user_id, :integer
  end
end
