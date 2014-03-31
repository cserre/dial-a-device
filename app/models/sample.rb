class Sample < ActiveRecord::Base
  attr_accessible :target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, :molecule_attributes, :compound_id, :originsample_id, :name

  # has_many :task_samples
  # has_many :tasks, :through => :task_samples

  has_many :molecule_samples

  belongs_to :molecule, :autosave => true, inverse_of: :samples

  belongs_to :originsample, :class_name => Sample, :foreign_key => :originsample_id

  accepts_nested_attributes_for :molecule 


  has_many :sample_reactions
  has_many :reactions,
  	:through => :sample_reactions

  has_many :datasets



  class CrossRef
    include HTTParty
    debug_output $stderr
    base_uri 'http://search.crossref.org'


    def get_record(doi)
      # options = { :query => {:doi => doi, :url => url}, 
      #             :basic_auth => @auth, :headers => {'Content-Type' => 'text/plain'} }

      options = { :timeout => 3,  :headers => {'Content-Type' => 'text/json'}  }

      self.class.get('http://search.crossref.org/dois?q='+doi, options)
    end

  end

  def add_literature(doi)

    res = CrossRef

    cr = CrossRef.new

    begin
          jsonresult = cr.get_record(doi)
    rescue
          jsonresult = nil
    end

    if !jsonresult.nil? && !jsonresult[0].nil? then

      puts jsonresult[0]

      c = Citation.new
      c.title = jsonresult[0]["title"]
      c.fullcitation = jsonresult[0]["fullCitation"]
      c.doi = doi
      c.save

      citations << c

    end

  end

  has_many :sample_citations
  has_many :citations,
    :through => :sample_citations

  def add_dataset(dataset)

    self.datasets << dataset

    self.projects.each do |p|
      p.add_dataset(dataset)
    end

  end

  def transfer_to_project(project)

    newsample = self.dup

    project.add_sample(newsample)

    return newsample

  end

  def name

    if read_attribute(:name).nil? then

      "S"+self.id.to_s

    else read_attribute(:name)


    end

  end

  def breadcrumbs

    s = self

    res = []

    while !s.originsample.nil? do

      s = s.originsample

      res << s.name
     
    end

    return res.join("/")

  end

  def longname

    s = self

    res = s.name

    if !breadcrumbs.empty? then res = breadcrumbs + "/"+res end

    return res

  end


  def role

      if self.is_virtual && self.is_startingmaterial then return "educt" end
     
      if self.is_virtual && !self.is_startingmaterial then return "reactant" end

      if !self.is_virtual && !self.is_startingmaterial then return "product" end
       
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

  def has_analytics?(reaction, methodpart)

    datasets = reaction.datasets.where(["molecule_id = ?", self.molecule.id])

    datasets.exists?(["method ilike ?", "%"+methodpart+"%"])

  end

  def has_unconfirmed_analytics?(current_user, reaction, methodpart)

    ms = Measurement.where(["user_id = ? and reaction_id = ? and molecule_id = ? and confirmed = ?", current_user.id, reaction.id, self.molecule.id, false])

    ms.each do |m|
      if m.dataset.method.include?(methodpart) then return true end

    end

    return false
  end

   # project association

  has_many :project_samples
  has_many :projects,
  through: :project_samples

  def add_to_project_recursive (project_id)

    p = Project.find(project_id)
    p.add_sample(self)

    if Project.exists?(Project.find(project_id).parent_id) then parent = p.parent end

    loop do

      if !parent.nil? then

        parent.add_sample(self)

      end

      break if parent.nil?

      break if parent.parent_id.nil?

      parent = Project.find(parent.parent_id)

    end

  end

 
end
