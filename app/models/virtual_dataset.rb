require 'dav4rack/resources/file_resource'

class VirtualDataset < DAV4Rack::Resource

  def children
  	#Dir[file_path + '/*'].map do |path|
  	#	child ::File.basename(path)
  	#end

  	puts "children?"
  	puts file_path

    puts request.env["HTTP_USER_AGENT"]

  	if _root?(file_path) then

  		# root folder, list all datasets

	  	user.datasets.map do |ds|

	        child ds.webdavpath
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
      puts request.env["HTTP_USER_AGENT"]

   	  res = false

      if _root?(file_path) then res = true end

   	  if _virtualdataset?(file_path) then res = true end

      if path == "/virtualdatasets/desktop.ini" then res = false end

      puts res

      res
   	  # return res

#     File.directory?(file_path)
#      @bson && _collection?(@bson['filename'])
    end



    # Does this recource exist?
    def exist?
#     File.exist?(file_path)
	  puts "exist?"
	  puts file_path
    puts request.env["HTTP_USER_AGENT"]

      res = false

      if _root?(file_path) then res = true end

   	  if _virtualdataset?(file_path) then res = true end

      if path == "/virtualdatasets/desktop.ini" then res = true end

      puts res
   	  res
    end



	def root
	    File.join(options[:root].to_s)
	  end

   def file_path
      full = File.join(root, path)

      full = full.sub(options[:root_uri_path], "")

      if full == "" then full = "/" end

      if full[0] == "" then full = "/" end

      puts full

      full
      
    end


    def stat
      #@stat ||= ::File.stat(file_path)

    end


  private
  
   def authenticate(username, password)
      self.user = User.where(["email = ?", username]).first
      user.try(:valid_password?, password)
   end  

   def _root?(path)
      path == "/"
   end


   def _virtualdataset?(path)

      puts "----virtualdataset?"
      puts "----"+path + " count "+path.count("/").to_s
      puts "----uri-root " + options[:root_uri_path].to_s

      res = false

      if path.count("/") == 1 then res = true end

        puts "----"+res.to_s
        res
    end



    

end