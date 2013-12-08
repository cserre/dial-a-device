class SamplePolicy < Struct.new(:user, :sample)
  class Scope < Struct.new(:user, :sample)
    def resolve
      user.molecules
    end
  end

  def show?
    result = false
    if !user.nil? && user.sampleviewer_of?(sample) then result = true end

    result
  end

  def create?
    true
  end

  def new?
    true
  end

  def assign?
    user.sampleowner_of?(sample)
  end

  def edit?
    user.sampleowner_of?(sample)
  end

  def update?
    user.sampleowner_of?(sample)
  end

  def destroy?
    user.sampleowner_of?(sample)
  end

end
