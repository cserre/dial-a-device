class Molecule < ActiveRecord::Base
  attr_accessible :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title


  has_many :datasets


  has_many :molecule_samples
  has_many :samples, :through => :molecule_samples, :dependent => :destroy, inverse_of: :compound


  # project association

  has_many :project_molecules
  has_many :projects,
  through: :project_molecules

  def add_to_project (project_id)

    pm = ProjectMolecule.new
    pm.molecule_id = self.id
    pm.project_id = project_id
    pm.save

  end
end
