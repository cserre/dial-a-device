class DatasetPolicy < Struct.new(:user, :dataset)
  class Scope < Struct.new(:user, :dataset)
    def resolve
      user.datasets
    end
  end

  def show?
    result = false
    if !user.nil? && user.datasetviewer_of?(dataset) then result = true end

    result
  end

  def edit?
    user.datasetowner_of?(dataset)
  end

  def create?
    true
  end

  def new?
    true
  end

  def update?
    user.datasetowner_of?(dataset)
  end

  def destroy?
    user.datasetowner_of?(dataset)
  end

end
