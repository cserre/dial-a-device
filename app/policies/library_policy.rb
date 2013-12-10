class LibraryPolicy < Struct.new(:user, :library)
  class Scope < Struct.new(:user, :library)
    def resolve
      user.libraries
    end
  end

  def show?
    result = false
    if !user.nil? && user.libraryviewer_of?(library) then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    user.libraryowner_of?(library)
  end

  def edit?
    user.libraryowner_of?(library)
  end

  def update?
    user.libraryowner_of?(library)
  end

  def destroy?
    user.libraryowner_of?(library)
  end

end
