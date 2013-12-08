class ProjectPolicy < Struct.new(:user, :project)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.projects.includes(:project_memberships).where(["project_memberships.role_id = ?", 99]).uniq
    end
  end

  class JointScope < Struct.new(:user, :scope)
    def resolve
      user.projects.includes(:project_memberships).where(["project_memberships.role_id = ?", 88]).uniq
    end
  end

  def show?
    user.projectowner_of?(project)
  end

  def create?
    true
  end

  def new?
    true
  end

  def adduser?
    user.projectowner_of?(project)
  end

  def edit?
    user.projectowner_of?(project)
  end

  def update?
    user.projectowner_of?(project)
  end

  def destroy?
    user.projectowner_of?(project)
  end

end
