class Sample < ActiveRecord::Base
  attr_accessible :target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :molecule_attributes, :compound_id

  # has_many :task_samples
  # has_many :tasks, :through => :task_samples

  has_many :molecule_samples
  belongs_to :molecule, :autosave => true, inverse_of: :samples

  accepts_nested_attributes_for :molecule 


  has_many :sample_reactions
  has_many :reactions,
  	:through => :sample_reactions

  def name
    molecule.name
  end

  def molecule_attributes=(molecule_attr)

    if (molecule_attr['id'] != nil && molecule_attr[:id] != '') then
      if _molecule = Molecule.find(molecule_attr['id']) then

        self.molecule = _molecule
        return true
      end
    end

    self.molecule = Molecule.new (molecule_attr)

  end

   # project association

  has_many :project_samples
  has_many :projects,
  through: :project_samples

  def add_to_project (project_id)

    pm = ProjectSample.new
    pm.sample_id = self.id
    pm.project_id = project_id
    pm.save

  end
 
end
