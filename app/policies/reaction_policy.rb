class ReactionPolicy < Struct.new(:user, :reaction)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.reactions
    end
  end

  def show?
    user.reactionviewer_of?(reaction)
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    user.reactionowner_of?(reaction)
  end

  def update?
    user.reactionowner_of?(reaction)
  end

  def destroy?
    user.reactionowner_of?(reaction)
  end

  def delete?
    user.reactionowner_of?(reaction)
  end
end
