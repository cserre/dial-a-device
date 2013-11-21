class MoleculePolicy < Struct.new(:user, :molecule)
  class Scope < Struct.new(:user, :molecule)
    def resolve
      user.molecules
    end
  end

  def show?
    result = false
    if !user.nil? && user.moleculeowner_of?(molecule) then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    user.moleculeowner_of?(molecule)
  end

  def edit?
    user.moleculeowner_of?(molecule)
  end

  def update?
    user.moleculeowner_of?(molecule)
  end

  def destroy?
    user.moleculeowner_of?(molecule)
  end

end
