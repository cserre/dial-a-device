class FolderWatcherPolicy < Struct.new(:user, :folder_watcher)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.folder_watchers
    end
  end

  def show?
    user.folder_watcher_viewer_of?(folder_watcher)
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    user.folder_watcher_owner_of?(folder_watcher)
  end

  def edit?
    user.folder_watcher_owner_of?(folder_watcher)
  end

  def update?
    user.folder_watcher_owner_of?(folder_watcher)
  end

  def destroy?
    user.folder_watcher_owner_of?(folder_watcher)
  end

end
