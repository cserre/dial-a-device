class ProjectReaction < ActiveRecord::Base
  attr_accessible :project_id, :reaction_id

  belongs_to :project
  belongs_to :reaction
end