class ProjectDataset < ActiveRecord::Base
  attr_accessible :dataset_id, :project_id, :user_id

  belongs_to :project
  belongs_to :dataset

  validates_uniqueness_of :dataset_id, :scope => [:project_id]

   def permission_str(user)

  	return_val = []

  	if ProjectDatasetPolicy.new(user, self).destroy? then return_val << "delete" end

  	if ProjectDatasetPolicy.new(user, self).edit? then return_val << "edit" end

  	if ProjectDatasetPolicy.new(user, self).show? then return_val << "show" end

  	return return_val.join(",")
  		
  end
end
