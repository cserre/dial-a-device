class CreateProjectFolderWatchers < ActiveRecord::Migration
  def change
    create_table :project_folder_watchers do |t|
      t.integer :project_id
      t.integer :folder_watcher_id

      t.timestamps
    end
  end
end
