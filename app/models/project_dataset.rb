class ProjectDataset < ActiveRecord::Base
  attr_accessible :dataset_id, :project_id

  belongs_to :project
  belongs_to :dataset

  validates_uniqueness_of :dataset_id, :scope => [:project_id]
end
