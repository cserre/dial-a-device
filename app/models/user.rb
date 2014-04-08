class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  if LsiRailsPrototype::Application.config.useldap == true then
    devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable

    before_save :get_ldap_email
  else
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable
  end

  def get_ldap_email

    self.email = Devise::LDAP::Adapter.get_ldap_param(self.username, "mail").first

  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  attr_accessible :firstname, :lastname, :sign

  attr_accessible :skip_invitation


  #affiliations

  attr_accessible :affiliations_attributes

  has_many :user_affiliations
  has_many :affiliations,
    through: :user_affiliations

  accepts_nested_attributes_for :affiliations

  def affiliations_attributes=(attrib)

    attrib.each do |ind, affi|

      a = Affiliation.new

      newaffiliation_country = Country.find_or_create_by_title(affi[:country_title])

      newaffiliation_organization = newaffiliation_country.organizations.find_or_create_by_title(affi[:organization_title])

      newaffiliation_department = newaffiliation_organization.departments.find_or_create_by_title(affi[:department_title])

      newaffiliation_group = newaffiliation_department.groups.find_or_create_by_title(affi[:group_title])

      newaffiliation_country.save
      newaffiliation_organization.save
      newaffiliation_department.save
      newaffiliation_group.save

      if !newaffiliation_country.organizations.exists? (newaffiliation_organization) then
        newaffiliation_country.organizations << newaffiliation_organization
      end

      if !newaffiliation_organization.departments.exists? (newaffiliation_department) then
        newaffiliation_organization.departments << newaffiliation_department
      end

      if !newaffiliation_department.groups.exists? (newaffiliation_group) then
        newaffiliation_department.groups << newaffiliation_group
      end

      a.country = newaffiliation_country
      a.organization = newaffiliation_organization
      a.department = newaffiliation_department
      a.group = newaffiliation_group

      a.save

      affiliations << a

    end
  end


  # projects
  attr_accessible :rootproject_id

  after_create :create_rootproject

  has_many :project_memberships, :foreign_key => :user_id

  has_many :projects,
    through: :project_memberships, :foreign_key => :user_id

  belongs_to :rootproject, :class_name => Project

  def topprojects

    projects.where(["parent_id is null"])

  end

  def create_rootproject
    rp = Project.create!
    rp.save

    pm = ProjectMembership.new
    pm.user_id = self.id
    pm.project_id = rp.id
    pm.role_id = 99
    pm.save

    rp.create_rootlibrary

    update_attributes(:rootproject_id => rp.id)

  end

  def projectowner_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 99)
  end

  def projectmember_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 88)
  end


  ####### # elements associated with project

  # Molecules

  has_many :project_molecules
  has_many :molecules,
    through: :project_molecules

  def molecules
    Molecule.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def moleculeviewer_of?(molecule)
    Project.joins(:project_memberships).joins(:molecules).where(["project_memberships.role_id >= ? and molecule_id = ? and project_memberships.user_id = ?", 88, molecule.id, id]).exists?
  end

  def moleculeowner_of?(molecule)
    Project.joins(:project_memberships).joins(:molecules).where(["project_memberships.role_id >= ? and molecule_id = ? and project_memberships.user_id = ?", 99, molecule.id, id]).exists?
  end

 # Samples

  has_many :project_samples
  has_many :samples,
    through: :project_samples

  def samples
    Sample.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def sampleviewer_of?(sample)
    Project.joins(:project_memberships).joins(:samples).where(["project_memberships.role_id >= ? and sample_id = ? and project_memberships.user_id = ?", 88, sample.id, id]).exists?
  end

  def sampleowner_of?(sample)
    Project.joins(:project_memberships).joins(:samples).where(["project_memberships.role_id >= ? and sample_id = ? and project_memberships.user_id = ?", 99, sample.id, id]).exists?
  end

  # Datasets

  def datasets
    Dataset.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def datasetowner_of?(dataset)
    Project.joins(:project_memberships).joins(:datasets).where(["project_memberships.role_id >= ? and dataset_id = ? and project_memberships.user_id = ?", 99, dataset.id, id]).exists?
  end

  def datasetmanager_of?(dataset)
    Project.joins(:project_memberships).joins(:datasets).where(["project_memberships.role_id >= ? and dataset_id = ? and project_memberships.user_id = ?", 93, dataset.id, id]).exists?
  end

  def datasetviewer_of?(dataset)
    Project.joins(:project_memberships).joins(:datasets).where(["project_memberships.role_id >= ? and dataset_id = ? and project_memberships.user_id = ?", 88, dataset.id, id]).exists?
  end

  # FolderWatchers

  def folder_watchers
    FolderWatcher.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def folder_watcher_owner_of?(folderwatcher)
    Project.joins(:project_memberships).joins(:folder_watchers).where(["project_memberships.role_id >= ? and folder_watcher_id = ? and project_memberships.user_id = ?", 99, folderwatcher.id, id]).exists?
  end

  def folder_watcher_viewer_of?(folderwatcher)
    Project.joins(:project_memberships).joins(:folder_watchers).where(["project_memberships.role_id >= ? and folder_watcher_id = ? and project_memberships.user_id = ?", 88, folderwatcher.id, id]).exists?
  end

  # BeagleBones

  def beaglebones
    Beaglebone.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

    def beagleboneowner_of?(beaglebone)
    Project.joins(:project_memberships).joins(:beaglebones).where(["project_memberships.role_id >= ? and beaglebone_id = ? and project_memberships.user_id = ?", 99, beaglebone.id, id]).exists?
  end

  def beagleboneviewer_of?(beaglebone)
    Project.joins(:project_memberships).joins(:beaglebones).where(["project_memberships.role_id >= ? and beaglebone_id = ? and project_memberships.user_id = ?", 88, beaglebone.id, id]).exists?
  end

  # Vncrelays

  def vncrelays
    Vncrelay.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

    def vncrelayowner_of?(vncrelay)
    Project.joins(:project_memberships).joins(:vncrelays).where(["project_memberships.role_id >= ? and vncrelay_id = ? and project_memberships.user_id = ?", 99, vncrelay.id, id]).exists?
  end

  # Devices

  def devices
    Device.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def deviceowner_of?(device)
    Project.joins(:project_memberships).joins(:devices).where(["project_memberships.role_id >= ? and device_id = ? and project_memberships.user_id = ?", 99, device.id, id]).exists?
  end

  def deviceviewer_of?(device)
    Project.joins(:project_memberships).joins(:devices).where(["project_memberships.role_id >= ? and device_id = ? and project_memberships.user_id = ?", 88, device.id, id]).exists?
  end

  def deviceconroller_of?(device)
    Project.joins(:project_memberships).joins(:devices).where(["project_memberships.role_id >= ? and device_id = ? and project_memberships.user_id = ?", 88, device.id, id]).exists?
  end

  # Reactions

  def reactions
    Reaction.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def reactionowner_of?(reaction)
    Project.joins(:project_memberships).joins(:reactions).where(["project_memberships.role_id >= ? and reaction_id = ? and project_memberships.user_id = ?", 99, reaction.id, id]).exists?
  end

  def reactionviewer_of?(reaction)
    Project.joins(:project_memberships).joins(:reactions).where(["project_memberships.role_id >= ? and reaction_id = ? and project_memberships.user_id = ?", 88, reaction.id, id]).exists?
  end

  # Libraries

  def libraries
    Library.includes(:projects => :project_memberships).where(["project_memberships.user_id = ?", id])
  end

  def libraryowner_of?(library)
    Project.joins(:project_memberships).joins(:libraries).where(["project_memberships.role_id >= ? and library_id = ? and project_memberships.user_id = ?", 99, library.id, id]).exists?
  end

  def libraryviewer_of?(library)
    Project.joins(:project_memberships).joins(:libraries).where(["project_memberships.role_id >= ? and library_id = ? and project_memberships.user_id = ?", 88, library.id, id]).exists?
  end

end
