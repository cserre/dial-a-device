class Beaglebone < ActiveRecord::Base
  attr_accessible :internal_ip, :serialnumber, :updateonnextboot, :version, :last_seen, :external_ip

  has_many :project_beaglebones
  has_many :projects,
  through: :project_beaglebones, :dependent => :destroy

  def add_to_project (project_id, user)

    pm = ProjectBeaglebone.new
    pm.beaglebone_id = self.id
    pm.project_id = project_id
    pm.user_id = user.id
    pm.save

  end
end
