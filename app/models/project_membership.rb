class ProjectMembership < ActiveRecord::Base
  attr_accessible :project_id, :role_id, :user_id

  belongs_to :user
  belongs_to :project
end
