class OrganizationDepartment < ActiveRecord::Base
  attr_accessible :department_id, :organization_id

  belongs_to :organization
  belongs_to :department

  validates :organization, :department, presence: true

  validates_uniqueness_of :organization_id, :scope => [:department_id]
end
