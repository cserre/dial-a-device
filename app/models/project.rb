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

  has_many :project_datasets
  has_many :datasets,
    through: :project_datasets

  has_many :project_beaglebones
  has_many :beaglebones,
    through: :project_beaglebones

  has_many :project_folder_watchers
  has_many :folder_watchers,
    through: :project_folder_watchers


  has_many :project_devices
  has_many :devices,
    through: :project_devices

  has_many :project_reactions
  has_many :reactions,
    through: :project_reactions

end
