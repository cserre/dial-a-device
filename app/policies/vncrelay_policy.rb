class VncrelayPolicy < Struct.new(:user, :vncrelay)
  class Scope < Struct.new(:user, :scope)
    def resolve
      user.vncrelays
    end
  end

  def show?
    user.vncrelayowner_of?(vncrelay)
  end

  def create?
    true
  end

  
  def new?
    true
  end

  def edit?
    user.vncrelayowner_of?(vncrelay)
  end

  def update?
    user.vncrelayowner_of?(vncrelay)
  end

  def destroy?
    user.vncrelayowner_of?(vncrelay)
  end

  def assign?
  	user.vncrelayowner_of?(vncrelay)
  end

end
