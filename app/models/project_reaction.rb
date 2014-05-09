class ProjectReaction < ActiveRecord::Base
  attr_accessible :project_id, :reaction_id, :user_id

  belongs_to :project
  belongs_to :reaction

  def permission_str(user)

  	return_val = []

  	if ProjectReactionPolicy.new(user, self).destroy? then return_val << "delete" end

  	if ProjectReactionPolicy.new(user, self).edit? then return_val << "edit" end

  	if ProjectReactionPolicy.new(user, self).show? then return_val << "show" end

  	return return_val.join(",")
  		
  end
end
