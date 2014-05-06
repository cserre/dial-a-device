class ProjectReactionPolicy < Struct.new(:user, :project_reaction)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.reactions
    end
  end

  def show?
    user.reactionviewer_of?(project_reaction.reaction)
  end

  def new?
    ProjectPolicy.new(user, project_reaction.project).addreaction?
  end

  def create?
    ProjectPolicy.new(user, project_reaction.project).addreaction?
  end

  def assign?
    ProjectPolicy.new(user, project_reaction.project).addreaction?
  end

  def edit?
    user.reactionowner_of?(project_reaction.reaction)
  end

  def update?
    user.reactionowner_of?(project_reaction.reaction)
  end

  def destroy?
    user.reactionowner_of?(project_reaction.reaction)
  end

  def delete?
    user.reactionowner_of?(project_reaction.reaction)
  end
end
