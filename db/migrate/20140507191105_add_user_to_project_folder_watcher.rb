class AddUserToProjectFolderWatcher < ActiveRecord::Migration
  def change
    add_column :project_folder_watchers, :user_id, :integer
  end
end
