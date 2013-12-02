class Department < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization

  has_many :department_groups
  has_many :groups,
  	through: :department_groups
end
