class Molecule < ActiveRecord::Base
  attr_accessible :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title

  attr_accessor :reaction_id, :role, :project_id

  has_many :datasets


  has_many :molecule_samples
  has_many :samples, :through => :molecule_samples, 
    :dependent => :destroy


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

  def add_to_project_recursive (project_id)

    p = Project.find(project_id)
    p.add_molecule(self)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_molecule(self)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end


end
