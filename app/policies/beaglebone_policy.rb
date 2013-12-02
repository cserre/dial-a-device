class BeaglebonePolicy < Struct.new(:user, :beaglebone)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.beaglebones
    end
  end

  def show?
    user.beagleboneviewer_of?(beaglebone)
  end

  def create?
    true
  end

  def edit?
    user.beagleboneowner_of?(beaglebone)
  end

  def update?
    user.beagleboneowner_of?(beaglebone)
  end

  def destroy?
    user.beagleboneowner_of?(beaglebone)
  end

  def assign?
  	user.beagleboneowner_of?(beaglebone)
  end

end
