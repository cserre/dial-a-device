class ProjectSamplePolicy < Struct.new(:user, :project_sample)
  class Scope < Struct.new(:user, :project_sample)
    def resolve
      user.samples
    end
  end

  def show?
    result = false
    if !user.nil? && user.sampleviewer_of?(project_sample.sample) then result = true end

    result
  end

  def new?
    ProjectPolicy.new(user, project_sample.project).addsample?
  end

  def create?
    ProjectPolicy.new(user, project_sample.project).addsample?
  end

  def assign?
    ProjectPolicy.new(user, project_sample.project).addsample?
  end

  def edit?
    result = false
    if !user.nil? && user.sampleowner_of?(project_sample.sample) then result = true end

    result
  end

  def update?
    user.sampleowner_of?(project_sample.sample)
  end

  def destroy?
    user.sampleowner_of?(project_sample.sample)
  end

end
