require 'dav4rack/resources/file_resource'

class VirtualDataset < DAV4Rack::Resource

  def children
  	#Dir[file_path + '/*'].map do |path|
  	#	child ::File.basename(path)
  	#end

  	puts "children?"
  	puts file_path

  	if file_path == '/virtualdatasets/' then

  		# root folder, list all datasets

	  	user.datasets.map do |ds|

	        child beautify(ds.id.to_s+"-"+ds.method + "-" +ds.title)
	    end

	elsif _virtualdataset?(file_path) then

  		datasetstring = file_path.split("/").last

  		#dataset = Dataset.find(datasetstring.split("-").first)

  		#dataset.attachments.map do |at|

	    #    child beautify(at.filename)
	    #end
	    return []
	end

  end

  def collection?
   	  puts "collection?"
   	  puts file_path

   	  res = false

   	  if file_path == '/virtualdatasets/' then res = true end

   	  if _virtualdataset?(file_path) then res = true end

   	  res

#     File.directory?(file_path)
#      @bson && _collection?(@bson['filename'])
    end



    # Does this recource exist?
    def exist?
#     File.exist?(file_path)
	  puts "exist?"
	  puts file_path

      res = false

   	  if path == '/virtualdatasets/' then res = true end

   	  if _virtualdataset?(path) then res = true end

   	  true
    end



	def root
	    File.join(options[:root].to_s)
	  end

   def file_path
      ::File.join(root, path)
      
    end


    def stat
      #@stat ||= ::File.stat(file_path)

    end


  private
  
   def authenticate(username, password)
      self.user = User.where(["email = ?", username]).first
      user.try(:valid_password?, password)
   end  


   def _virtualdataset?(path)

      puts path.count("/")

      if path.count("/") == 2 && path.split("/").last != "" then true else false end
    end


    def beautify(path)
    	newpath = path.gsub("/", "_")
    	newpath = newpath.gsub(" ", "_")
    	newpath
    end

    

end