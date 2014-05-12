class ProjectMolecule < ActiveRecord::Base
  attr_accessible :molecule_id, :project_id, :user_id

  belongs_to :project
  belongs_to :molecule

  validates_uniqueness_of :molecule_id, :scope => [:project_id]

   def permission_str(user)

  	return_val = []

  	if ProjectMoleculePolicy.new(user, self).destroy? then return_val << "delete" end

  	if ProjectMoleculePolicy.new(user, self).edit? then return_val << "edit" end

  	if ProjectMoleculePolicy.new(user, self).show? then return_val << "show" end

  	return return_val.join(",")
  		
  end

end
