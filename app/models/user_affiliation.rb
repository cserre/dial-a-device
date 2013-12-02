class UserAffiliation < ActiveRecord::Base
  attr_accessible :affiliation_id, :user_id

  belongs_to :user
  belongs_to :affiliation
end
