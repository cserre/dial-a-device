class ProjectDatasetPolicy < Struct.new(:user, :project_dataset)
  class Scope < Struct.new(:user, :project_dataset)
    def resolve
      user.datasets
    end
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

  def show?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_dataset.project_id, user.id]).first

    if project_membership.role_id >= 88 then return true end

    return false
  
  end

  def edit?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_dataset.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def update?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_dataset.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def destroy?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_dataset.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def delete?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_dataset.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

end
