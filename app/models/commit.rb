class Commit < ActiveRecord::Base
	attr_accessible :dataset_id, :user_id

	belongs_to :dataset
	belongs_to :user
end
