class ProjectMolecule < ActiveRecord::Base
  attr_accessible :molecule_id, :project_id, :user_id

  belongs_to :project
  belongs_to :molecule

  validates_uniqueness_of :molecule_id, :scope => [:project_id]

end
