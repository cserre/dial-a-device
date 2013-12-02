class Organization < ActiveRecord::Base
  attr_accessible :title

  belongs_to :country

  has_many :organization_departments
  has_many :departments,
  	through: :organization_departments
end
