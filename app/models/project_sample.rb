class ProjectSample < ActiveRecord::Base
  attr_accessible :sample_id, :project_id, :user_id

  belongs_to :project
  belongs_to :sample

  validates_uniqueness_of :sample_id, :scope => [:project_id]

  def permission_str(user)

  	return_val = []

  	if ProjectSamplePolicy.new(user, self).destroy? then return_val << "delete" end

  	if ProjectSamplePolicy.new(user, self).edit? then return_val << "edit" end

  	if ProjectSamplePolicy.new(user, self).show? then return_val << "show" end

  	return return_val.join(",")
  		
  end
end
