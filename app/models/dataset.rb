class Dataset < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  attr_accessible :attachments, :molecule_id, :title, :description, :method, :details, :preview_id

  has_many :attachments, :dependent => :destroy

  belongs_to :molecule

  has_one :measurement, :dependent => :destroy

  has_many :datasetgroup_datasets
  has_many :datasetgroups,
    through: :datasetgroup_datasets

  has_many :commits

  # acts_as_list scope: :datasetgroup_dataset

  def oai_dc_identifier
  	"http://dx.doi.org/"+doi_identifier
  end

  def doi_identifier
  	if !molecule.nil? then 

      v = ""
      if (!version.blank? && !(version == "0")) then v = "."+version end

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

  def assign_method_rank

    m = self.method

    r = 0

    if !m.nil? then
      if m.start_with?('Rf') then r = 10 end
      if m.start_with?('NMR/1H') then r = 20 end
      if m.start_with?('NMR/13C') then r = 30 end
      if m.start_with?('IR') then r = 40 end
      if m.start_with?('Mass') then r = 50 end
      if m.start_with?('GCMS') then r = 60 end
      if m.start_with?('Raman') then r = 65 end
      if m.start_with?('UV') then r = 70 end
      if m.start_with?('TLC') then r = 75 end
      if m.start_with?('Xray') then r = 80 end
    end

    self.method_rank = r

  end

  # analysis methods

  def detect_parameters

    attachments.each do |a|
      if a.folder == "pdata/1/" && a.read_attribute(:file) == "proc" then

        scanfreq = "0"
        a.file.read.each_line do |line|
          key, value = line.split("=")

          if !(key.nil?) && !(value.nil?) then

            if "\#\#\$TI".start_with?(key.to_s) then
              t = value.to_s.strip.delete("<>")
              if !(t.blank?) then 
                self.update_attribute(:title, t)
              end
            end

            if "\#\#\$SF".start_with?(key.to_s) then
              scanfreq = number_with_precision(value.to_s.strip.delete("<>").to_f, :precision => 0)
            end

            if "\#\#\$SREGLST".start_with?(key.to_s) then
              t = value.to_s.strip.delete("<>")

              nucleus, solvent = t.split(".")

              m = "NMR/" + nucleus + "/" + solvent + "/" + scanfreq
              self.update_attribute(:method, m)
            end

          end
        end
      end

      if a.folder == "pdata/1/" && a.read_attribute(:file) == "title" then

        puts "title file"

        content = a.file.read
          t = content.squish
          puts t
          if !(t.blank?) then 
            self.update_attribute(:title, t)
          end
    
      end

      ## detect Agilent GCMS

      if a.folder == "" && a.read_attribute(:file) == "runstart.txt" then

        # self.update_attribute(:title, t)
    
      end


      ## detect Agilent HPLC

      if a.folder == "" && (a.read_attribute(:file).downcase == "report.txt") then

        a.file.read.each_line do |line|

          if (line.start_with?("Sample Name")) then
            k, v = line.split(":")
            
            t = v.squish

            if !(t.blank?) then 
              if !(t.start_with?("Blank")) then
                self.update_attribute(:title, t)
              end
            end
          end
    
        end
      end

    end

  end

end
