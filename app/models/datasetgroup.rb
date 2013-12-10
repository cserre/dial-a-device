class Datasetgroup < ActiveRecord::Base

  attr_accessible :datasets

  has_many :datasetgroup_datasets
  has_many :datasets,
  	through: :datasetgroup_datasets,
  	:order => "position ASC"
end
