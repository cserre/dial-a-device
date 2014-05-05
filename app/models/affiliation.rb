class Affiliation < ActiveRecord::Base
  attr_accessible :country_title, :organization_title, :department_title, :group_title

  has_many :user_affiliations
  has_many :users,
    through: :user_affiliations, :dependent => :destroy

  belongs_to :country
  belongs_to :organization
  belongs_to :group
  belongs_to :department

  def country_title
  	country.title if country
  end

  def country_title=(name)
  	self.country = Country.find_or_create_by_title(name) unless name.blank?
  end


  def organization_title
  	organization.title if organization
  end

  def organization_title=(name)
  	self.organization = Organization.find_or_create_by_title(name) unless name.blank?
  end


  def department_title
  	department.title if department
  end

  def department_title=(name)
  	self.department = Department.find_or_create_by_title(name) unless name.blank?
  end


  def group_title
  	group.title if group
  end

  def group_title=(name)
  	self.group = Group.find_or_create_by_title(name) unless name.blank?
  end

end
