class ProjectLibrary < ActiveRecord::Base
	attr_accessible :library_id, :project_id, :user_id

  belongs_to :project
  belongs_to :library
end
