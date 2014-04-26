class PagesController < ApplicationController

  before_filter :authenticate_user!, only: [:import, :importzip]

  def welcome
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def about
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def webdav
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def import

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  def importzip

    samples = []

    reactions = []

    Zip::File.open(params[:upload][:file].path) do |zip_file|

      zip_file.each do |entry|

        if entry.name.start_with?("sample") then 

          samples << JSON.parse(entry.get_input_stream.read)

        end

        if entry.name.start_with?("reaction") then 

          reactions << JSON.parse(entry.get_input_stream.read)

        end
      end

      reactions.each do |r|

        r.delete("id")
        r.delete("created_at")
        r.delete("updated_at")
        r.delete("molecule_id")
        r.delete("guid")

        samples = r["samples"]

        r.delete("samples")

        reaction = Reaction.new(r)

        reaction.save


        samples.each do |sa|


          sample = addsample(sa, zip_file)

          reaction.samples << sample

        end


        Project.find(current_user.rootproject_id).add_reaction(reaction)
        


      end


      samples.each do |s|

        addsample(s, zip_file)
        
      end


    end

    redirect_to "/samples"

  end

  private

  def addsample(s, zip_file)

        s.delete("id")
        s.delete("created_at")
        s.delete("updated_at")
        s.delete("molecule_id")
        s.delete("guid")

               
        datasets = []

        dx = s["datasets"]        

        s.delete("datasets")

        if !s["molecule"].blank? then

                  s["molecule"].delete("id")
        s["molecule"].delete("created_at")
        s["molecule"].delete("updated_at")

        @molecule = Molecule.new(s["molecule"])

          virtualmolecule = Rubabel::Molecule.from_string(@molecule.molfile, :mdl)
          
          existingmolecules = Molecule.where (["inchikey = ?", virtualmolecule.to_s(:inchikey).gsub(/\n/, "").strip])
          existingmolecule = existingmolecules.first

          if (existingmolecule != nil) then
            if (existingmolecule.id != nil) then
              success = true
              @molecule = existingmolecule

            end
          else
            success = @molecule.save
            
          end

        end

        s.delete("molecule")

        if success then 

          sample = Sample.new(s)

          sample.molecule = @molecule

          sample.save
          @molecule.samples << sample


          dx.each do |ds|

            ds.delete("version")
            ds.delete("molecule_id")

            old_dataset_id = ds["id"]
            ds.delete("id")

            ds.delete("position")
            ds.delete("uniqueid")
            ds.delete("id")
            ds.delete("created_at")
            ds.delete("updated_at")
            ds.delete("sample_id")


            attachments = ds["attachments"]
            ds.delete("attachments")

            dataset = Dataset.new(ds)

            dataset.save

            dsg = Datasetgroup.new
            dsg.save
            dsg.datasets << dataset


            attachments.each do |att|

              newattachment = Attachment.new(:dataset => dataset)

              puts "ATT"
              puts att

              newattachment.folder = att["folder"]

              if Rails.env.localserver? then 

                localpath = LsiRailsPrototype::Application.config.datasetroot + "datasets/#{dataset.id}/#{att["folder"]}#{att["filename"]}"

                FileUtils.mkdir_p(File.dirname(localpath))

                zip_file.extract(old_dataset_id.to_s+"/"+att["filename"] , localpath)

                newattachment.file = File.new(localpath)
                newattachment.save


              else
                localpath = Rails.root.join('tmp').join(att["filename"])

                File.delete(localpath) if File.exist?(localpath)

                FileUtils.mkdir_p(File.dirname(localpath))

                zip_file.extract(old_dataset_id.to_s+"/"+att["filename"] , localpath)

                newattachment.file = File.open(localpath)
                newattachment.save

                File.delete(localpath) if File.exist?(localpath)
              end

              dataset.add_attachment(newattachment)

            end

            sample.add_dataset(dataset)

            Project.find(current_user.rootproject_id).add_dataset(dataset)

          end

          Project.find(current_user.rootproject_id).add_sample(sample)

        end

      return sample
  end
end
