class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :invitable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  attr_accessible :firstname, :lastname, :sign

  attr_accessible :skip_invitation

  # projects
  attr_accessible :rootproject_id

  after_create :create_rootproject

  has_many :project_memberships, :foreign_key => :user_id

  has_many :projects,
    through: :project_memberships, :foreign_key => :user_id

  has_one :rootproject

  def create_rootproject
    rp = Project.create!
    rp.save

    pm = ProjectMembership.new
    pm.user_id = self.id
    pm.project_id = rp.id
    pm.role_id = 99
    pm.save

    update_attributes(:rootproject_id => rp.id)

  end

  def projectowner_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 99)
  end

  def projectmember_of?(project)
    project_memberships.exists?(:user_id => id, :project_id => project.id, :role_id => 88)
  end

end
