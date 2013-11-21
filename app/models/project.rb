class Project < ActiveRecord::Base
  attr_accessible :parent_id, :title

  has_many :project_memberships

  def members
  	User.joins(:project_memberships).where(["role_id = ? and project_id = ?", 88, id])
  end

  def owner
  	User.joins(:project_memberships).where(["role_id = ? and project_id = ?", 99, id]).first
  end


  # associations

  has_many :project_molecules
  has_many :molecules,
    through: :project_molecules

end