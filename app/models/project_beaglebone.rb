class ProjectBeaglebone < ActiveRecord::Base
  attr_accessible :beaglebone_id, :project_id, :user_id

  belongs_to :project
  belongs_to :beaglebone
end
