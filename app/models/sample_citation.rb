class SampleCitation < ActiveRecord::Base


	attr_accessible :sample_id, :citation_id

  belongs_to :sample
  belongs_to :citation

  validates :sample, :citation, presence: true
end
