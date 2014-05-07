class FolderWatcher < ActiveRecord::Base
  attr_accessible :device_id, :pattern, :rootfolder, :scanfilter, :serialnumber, :lastseen

  has_many :project_folder_watchers
  has_many :projects,
  through: :project_folder_watchers, :dependent => :destroy

  def add_to_project (project_id, user)

    pm = ProjectFolderWatcher.new
    pm.folder_watcher_id = self.id
    pm.project_id = project_id
    pm.user_id = user.id
    pm.save

  end

end
