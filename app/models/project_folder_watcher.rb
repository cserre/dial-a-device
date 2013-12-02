class ProjectFolderWatcher < ActiveRecord::Base
  attr_accessible :folder_watcher_id, :project_id

  belongs_to :project
  belongs_to :folder_watcher
end
