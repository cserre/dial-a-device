class DepartmentGroup < ActiveRecord::Base
  attr_accessible :department_id, :group_id

  belongs_to :department
  belongs_to :group

  validates :department, :group, presence: true

  validates_uniqueness_of :department_id, :scope => [:group_id]
end
