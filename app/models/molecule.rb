class String
  def hex_to_binary
    temp = gsub("\s", "");
    ret = []
    (0...temp.size()/2).each{|index| ret[index] = [temp[index*2, 2]].pack("H2")}
    return ret
  end
end

class Molecule < ActiveRecord::Base
  attr_accessible :charge, :formula, :inchi, :inchikey, :mass, :molfile, :published_at, :spin, :smiles, :title, :fp

  attr_accessor :reaction_id, :role, :project_id

  before_save :update_fingerprints

  has_many :datasets


  has_many :molecule_samples
  has_many :samples,
    :through => :molecule_samples, :dependent => :destroy


  def as_json(options= {})
    h = super(options)
    h[:svg] = self.svg
    h
  end

  def svg(highlight="")

      c=OpenBabel::OBConversion.new
        c.set_out_format 'svg'
        c.set_in_format 'mol'

        if !highlight.blank? then

          c.add_option 's', OpenBabel::OBConversion::GENOPTIONS, highlight+" green"

        end

        c.set_options 'd u', OpenBabel::OBConversion::OUTOPTIONS
     
        m=OpenBabel::OBMol.new
        c.read_string m, self.molfile

        #m.do_transformations c.get_options(OpenBabel::OBConversion::GENOPTIONS), c

        c.write_string(m, false)

  end

  def update_fingerprints

    self.fp = fp2 if molfile

  end

  def fp2

      c=OpenBabel::OBConversion.new
        c.set_out_format 'fpt'
        c.set_in_format 'mol'
        c.set_options 'f FP2 h N 1024', OpenBabel::OBConversion::OUTOPTIONS

        m=OpenBabel::OBMol.new
        c.read_string m, self.molfile

        res = c.write_string(m, false)

        res = res.gsub(" ", "").split(/\n/)[1..-1].join.hex.to_s(2).ljust(1024, '0')

  end
  # project association

  has_many :project_molecules
  has_many :projects,
  through: :project_molecules, :dependent => :destroy

  def add_to_project_recursive (project_id, user)

    p = Project.find(project_id)
    p.add_molecule(self, user)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_molecule(self, user)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end


end
