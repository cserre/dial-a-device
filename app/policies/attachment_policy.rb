class AttachmentPolicy < Struct.new(:user, :attachment)
  class Scope < Struct.new(:user, :attachment)
    def resolve
      # user.molecules
    end
  end

  def show?
    result = false
    if !user.nil? && user.datasetviewer_of?(attachment.dataset) then result = true end

    result
  end

  def serve?
    show?
  end

  def edit?
    user.datasetowner_of?(attachment.dataset)
  end

  def create?
    true
  end

  def link?
    true
  end


  def new?
    true
  end

  def update?
    user.datasetowner_of?(attachment.dataset)
  end

  def destroy?
    user.datasetowner_of?(attachment.dataset)
  end

end
