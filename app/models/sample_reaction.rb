class SampleReaction < ActiveRecord::Base
  attr_accessible :reaction_id, :sample_id

  belongs_to :reaction
  belongs_to :sample

  validates :reaction, :sample, presence: true

  validates_uniqueness_of :sample_id, :scope => [:reaction_id]

end
