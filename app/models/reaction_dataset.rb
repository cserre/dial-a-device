class ReactionDataset < ActiveRecord::Base

  attr_accessible :reaction_id, :dataset_id

  belongs_to :reaction
  belongs_to :dataset
end
