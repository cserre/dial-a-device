class Dataset < ActiveRecord::Base
  attr_accessible :attachments, :molecule_id, :title, :description, :method, :details, :preview_id

  has_many :attachments, :dependent => :destroy

  belongs_to :molecule

  has_one :measurement, :dependent => :destroy

  def oai_dc_identifier
  	"http://dx.doi.org/"+doi_identifier
  end

  def doi_identifier
  	if !molecule.nil? then 

      v = ""
      if (!version.nil? && !version.empty?  && !version == "0") then v = "."+version end

  		if !ENV['DOI_PREFIX'].nil? then
  			ENV['DOI_PREFIX']+"/"+molecule.inchikey+"/"+method+v
  		end
  	end

  end

def preview_url
    if !preview_id.nil? then
      at = Attachment.find(preview_id).first
    else
      at = attachments.where(["file = ? or file = ? or file = ? or file = ?", "preview.jpg", "preview.jpeg", "preview.JPG", "preview.JPEG"]).first

      if (at.nil?) then
        # select the best fit

        at = attachments.where(["file ilike ? or file ilike ? or file ilike ?", "%jpg", "%pdf", "%gif"]).first        
      end
    end

    if (!at.nil?) then
      at.file.thumb.url
    else
      "/nopreview.jpg"
    end

  end

  has_many :project_datasets

  has_many :projects,
  through: :project_datasets

  def add_to_project (project_id)

    pm = ProjectDataset.new
    pm.dataset_id = self.id
    pm.project_id = project_id
    pm.save

  end

end
