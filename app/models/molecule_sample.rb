class MoleculeSample < ActiveRecord::Base
  attr_accessible :molecule_id, :sample_id

  belongs_to :molecule
  belongs_to :sample

  # accepts_nested_attributes_for :device, :user

  validates :molecule, :sample, presence: true

  # validates_uniqueness_of :compound_id, :scope => [:sample_id]


end
