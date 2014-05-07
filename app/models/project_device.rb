class ProjectDevice < ActiveRecord::Base
  attr_accessible :device_id, :project_id, :user_id

  belongs_to :device
  belongs_to :project
end
