class Library < ActiveRecord::Base

  attr_accessible :title

  has_many :library_entries, :order => "position ASC"

  has_many :project_libraries
  has_many :projects,
  through: :project_libraries

  def add_to_project (project_id)

    pm = ProjectLibrary.new
    pm.library_id = self.id
    pm.project_id = project_id
    pm.save

  end

end
