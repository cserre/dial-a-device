class CountryOrganization < ActiveRecord::Base
  attr_accessible :country_id, :organization_id

  belongs_to :country
  belongs_to :organization

  validates :country, :organization, presence: true

  validates_uniqueness_of :country_id, :scope => [:organization_id]
end
