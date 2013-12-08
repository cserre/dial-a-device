class ProjectSample < ActiveRecord::Base
  attr_accessible :sample_id, :project_id

  belongs_to :project
  belongs_to :sample

  validates_uniqueness_of :sample_id, :scope => [:project_id]

end
