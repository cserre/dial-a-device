require 'dav4rack/resources/file_resource'

class VirtualDataset < DAV4Rack::Resource

  def children

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
   	  
   	  res = false

      if _root?(file_path) then res = true end

   	  if _virtualdataset?(file_path) then res = true end

      if path == "/desktop.ini" then res = false end

      res
    end



    # Does this recource exist?
    def exist?

  	  puts "webdav exist? "+file_path+ "("+request.env["HTTP_USER_AGENT"]+")"

      res = false

      if _root?(file_path) then res = true end

   	  if _virtualdataset?(file_path) then res = true end

      if path == "/desktop.ini" then res = true end

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

      if full[0] != "/" then full = "/"+full end

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

      res = false

      if path.count("/") == 1 then res = true end

      res
    end
  

end