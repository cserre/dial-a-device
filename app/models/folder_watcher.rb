class FolderWatcher < ActiveRecord::Base
  attr_accessible :device_id, :pattern, :rootfolder, :scanfilter, :serialnumber

  has_many :project_folder_watchers
  has_many :projects,
  through: :project_folder_watchers

  def add_to_project (project_id)

    pm = ProjectFolderWatcher.new
    pm.folder_watcher_id = self.id
    pm.project_id = project_id
    pm.save

  end

end
