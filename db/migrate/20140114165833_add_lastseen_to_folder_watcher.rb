class AddLastseenToFolderWatcher < ActiveRecord::Migration
  def change
    add_column :folder_watchers, :lastseen, :datetime
  end
end
