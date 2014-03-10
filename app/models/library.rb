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

  def add_molecule(molecule_id)

    le = LibraryEntry.new
    le.molecule_id = molecule_id
    le.library_id = self.id
    le.save

  end

end
