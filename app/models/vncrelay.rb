class Vncrelay < ActiveRecord::Base
	attr_accessible :internal_ip, :serialnumber, :lastseen, :external_ip, :host, :port

  has_many :project_vncrelays
  has_many :projects,
  through: :project_vncrelays

  def add_to_project (project_id)

    pm = ProjectVncrelay.new
    pm.vncrelay_id = self.id
    pm.project_id = project_id
    pm.save

  end
end
