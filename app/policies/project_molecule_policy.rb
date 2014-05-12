class ProjectMoleculePolicy < Struct.new(:user, :project_molecule)
  class Scope < Struct.new(:user, :project_sample)
    def resolve
      user.samples
    end
  end

  def new?
    ProjectPolicy.new(user, project_molecule.project).addmolecule?
  end

  def create?
    ProjectPolicy.new(user, project_molecule.project).addmolecule?
  end

  def assign?
    ProjectPolicy.new(user, project_molecule.project).addmolecule?
  end

  def show?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_molecule.project_id, user.id]).first

    if project_membership.role_id >= 88 then return true end

    return false
  
  end

  def edit?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_molecule.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def update?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_molecule.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def destroy?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_molecule.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

  def delete?
    project_membership = ProjectMembership.where(["project_id = ? and user_id = ?", project_molecule.project_id, user.id]).first

    if project_membership.role_id >= 99 then return true end

    return false
  end

end
