class Molecule < ActiveRecord::Base
  attr_accessible :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title


  has_many :datasets


  has_many :molecule_samples
  has_many :samples, :through => :molecule_samples, :dependent => :destroy, inverse_of: :compound


  def as_json(options= {})
    h = super(options)
    h[:svg] = self.svg
    h
  end


  def svg

      c=OpenBabel::OBConversion.new
        c.set_out_format 'svg'
        c.set_in_format 'mol'
        c.set_options 'd u', OpenBabel::OBConversion::OUTOPTIONS

        m=OpenBabel::OBMol.new
        c.read_string m, self.molfile

        c.write_string(m, false)

  end
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
