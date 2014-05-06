class ProjectDatasetPolicy < Struct.new(:user, :project_dataset)
  class Scope < Struct.new(:user, :project_dataset)
    def resolve
      user.datasets
    end
  end

  def show?
    result = false
    if !user.nil? && user.datasetviewer_of?(project_dataset.dataset) then result = true end

    result
  end

  def edit?
    user.datasetowner_of?(project_dataset.dataset)
  end

  def new?
    ProjectPolicy.new(user, project_dataset.project).adddataset?
  end

  def create?
    ProjectPolicy.new(user, project_dataset.project).adddataset?
  end

  def assign?
    ProjectPolicy.new(user, project_dataset.project).adddataset?
  end

  def update?
    user.datasetowner_of?(project_dataset.dataset)
  end

  def destroy?
    user.datasetowner_of?(project_dataset.dataset)
  end

end
