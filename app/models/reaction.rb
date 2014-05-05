class Reaction < ActiveRecord::Base

  attr_accessible :name, :description, :samples_attributes, :educts_attributes, :reactants_attributes, :products_attributes
  

  # belongs_to :task, :dependent => :destroy

  has_many :sample_reactions
  has_many :samples,
    :through => :sample_reactions, :dependent => :destroy

  has_many :educts, :through => :sample_reactions, :source => :sample, :conditions => {:is_virtual => true, :is_startingmaterial => true}
  has_many :reactants, :through => :sample_reactions, :source => :sample, :conditions => {:is_virtual => true, :is_startingmaterial => false}

  has_many :products, :through => :sample_reactions, :source => :sample, :conditions => {:is_virtual => false}

  accepts_nested_attributes_for :samples, :allow_destroy => true
  accepts_nested_attributes_for :educts, :allow_destroy => true
  accepts_nested_attributes_for :reactants, :allow_destroy => true
  accepts_nested_attributes_for :products, :allow_destroy => true

  has_many :reaction_datasets
  has_many :datasets,
    through: :reaction_datasets, :dependent => :destroy


  has_many :project_reactions
  has_many :projects,
  	through: :project_reactions, :dependent => :destroy





  def has_unconfirmed_analytics?(current_user)

    ms = Measurement.where(["user_id = ? and reaction_id = ? and confirmed = ?", current_user.id, self.id, false])

    if ms.length > 0 then return true end

    return false
  end

  def add_to_project_recursive (project_id)

    p = Project.find(project_id)
    p.add_reaction(self)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_reaction(self)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end

    def remove_from_project(project)

    project.remove_reaction_only(self)

  end

  def remove_from_project_database(project)

    self.remove_from_project(project)

    if Project.exists?(project.parent_id) then parent = project.parent end

    loop do

      if !parent.nil? then

        self.remove_from_project(parent)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

    self.remove_from_project_children(project)

  end

  def remove_from_project_children(project)

    self.remove_from_project(project)

    project.children.each do |child|

      self.remove_from_project_children(child)

    end

  end

  def as_json(options={})
    super(:include => [:samples => {:include => [:molecule, :datasets => {:include => [:attachments => {:methods => [:filename, :filesize]}]}]}])
  end
end
