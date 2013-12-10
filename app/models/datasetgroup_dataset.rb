class DatasetgroupDataset < ActiveRecord::Base
  attr_accessible :datasetgroup_id, :dataset_id

  belongs_to :datasetgroup
  belongs_to :dataset

  validates :datasetgroup, :dataset, presence: true

  validates_uniqueness_of :datasetgroup_id, :scope => [:dataset_id]
end
