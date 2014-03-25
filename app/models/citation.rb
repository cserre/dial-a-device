class Citation < ActiveRecord::Base

  attr_accessible :title, :doi, :fullcitation
      

  has_many :sample_citations
  has_many :samples,
    :through => :sample_citations

end
