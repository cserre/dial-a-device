class ProjectVncrelay < ActiveRecord::Base
  attr_accessible :vncrelay_id, :project_id

  belongs_to :project
  belongs_to :vncrelay
end
