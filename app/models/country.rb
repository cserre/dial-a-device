class Country < ActiveRecord::Base
  attr_accessible :title

  has_many :country_organizations
  has_many :organizations,
  	through: :country_organizations
end
