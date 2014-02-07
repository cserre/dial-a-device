require 'dav4rack/resources/file_resource'

class VirtualDataset < DAV4Rack::Resource

  def children

  puts "children?"

  	if _root?(file_path) then

  		# root folder, list all datasets

	  	user.datasets.map do |ds|

	        child ds.webdavpath
	    end


  	elsif _virtualfolder?(file_path) then

    		_get_children(file_path).map do |res|
          child res
        end
  	    
  	else
      []

    end
      

  end

  def collection?

    puts "collection? " +file_path
   	  
   	  res = false

      if _root?(file_path) then res = true

      elsif _virtualdataset?(file_path) then res = true

   	  elsif _virtualfolder?(file_path) then res = true end

      if path == "/desktop.ini" then res = false end

      res
    end



    # Does this recource exist?
    def exist?



  	  puts "webdav exist? "+file_path+ " ("+request.env["HTTP_USER_AGENT"]+")"

      res = false

      if _root?(file_path) then res = true

      elsif _virtualdataset?(file_path) then res = true

   	  elsif _virtualfolder?(file_path) then res = true

      elsif _virtualfile?(file_path) then res = true end

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
      stat = ::File.stat( LsiRailsPrototype::Application.config.datasetroot)

      if _root?(file_path) then 

      elsif _virtualdataset?(file_path) then 

      elsif _virtualfolder?(file_path) then 

      elsif _virtualfile?(file_path) then stat = ::File.stat( LsiRailsPrototype::Application.config.datasetroot + _virtualfile(file_path).file.to_s ) end

        return stat
    end



    # Return the creation time.
    def creation_date
      stat.ctime
    end


    # Return the time of last modification.
    def last_modified
      stat.mtime
    end


    # Set the time of last modification.
    def last_modified=(time)
      ::File.utime(Time.now, time, LsiRailsPrototype::Application.config.datasetroot + _virtualfile(file_path).file.to_s)
    end


    # Return an Etag, an unique hash value for this resource.
    def etag
      sprintf('%x-%x-%x', stat.ino, stat.size, stat.mtime.to_i)
    end


    # Return the mime type of this resource.
    def content_type
      if stat.directory?
        "text/html"
      else
        #mime_type(file_path, DefaultMimeTypes)
        "text/plain"
      end
    end


    # Return the size in bytes for this resource.
    def content_length
      stat.size
    end



  def get(request, response)
      #raise NotFound unless exist?
#     if stat.directory?
#       response.body = ""
#       Rack::Directory.new(root).call(request.env)[2].each do |line|
#         response.body << line
#       end
#       response['Content-Length'] = response.body.size.to_s
#     else
#       file = Rack::File.new(root)
#       response.body = file
#     end
      if collection?
        response.body = "<html>"
        response.body << "<h2>" + file_path.html_safe + "</h2>"
        children.each do |child|
          name = child.file_path.html_safe
          path = child.public_path
          response.body << "<a href='" + path + "'>" + name + "</a>"
          response.body << "</br>"
        end
        response.body << "</html>"
        response['Content-Length'] = response.body.size.to_s
        response['Content-Type'] = 'text/html'
      else


        puts "open file " + LsiRailsPrototype::Application.config.datasetroot + _virtualfile(file_path).file.to_s

      File.open(LsiRailsPrototype::Application.config.datasetroot + _virtualfile(file_path).file.to_s, 'r') do |f|

       # response.body = f

          f.lines.each do |l|
             response.body << l
          end
        

        end

        #localfile = LsiRailsPrototype::Application.config.datasetroot+ _virtualfile(file_path).file.to_s

   # puts localfile
  

       #file = Rack::File.new(LsiRailsPrototype::Application.config.datasetroot + _virtualfile(file_path).file.to_s)
       # puts file.to_s

       #response.body = file
    
      end

      puts "serving..."

      OK

    end



  private
  
   def authenticate(username, password)

      
      self.user = User.where(["email = ?", username]).first
      user.try(:valid_password?, password)
   end  

   def _root?(path)
      path == "/"
   end


   def _virtualfolder?(path)

    ds = _get_dataset (path)

    res = false

    if !ds.nil?

      ds.uniquefolders?.each do |uf|

        if uf.starts_with?(_get_subpath(path)) then  res = true end

      end

      if _get_subpath(path) == "" then res = true end

    end

    res

   end

   def _virtualfile(path)

    res = nil

    ds = _get_dataset(path)

      ds.attachments.each do |at|

        puts "get subpath "+_get_subpathoffile(path)
        puts "path "+path

        if (at.folder?).starts_with?(_get_subpathoffile(path)) || (_get_subpathoffile(path) == "")  then 

          if at.filename? == path.split("/").last then 

            res = at

          end
        end
      end


      res


   end

   def _virtualfile?(path)
     !_virtualfile(path).nil?
   end


   def _get_children(path)

    puts "get children "+path

    ds = _get_dataset(path)

    if !ds.nil? then

      ds_children(ds, _get_subpath(path))

    end

   end


   def _virtualdataset?(path)

      res = false

      if path.count("/") == 1 then res = true end

      res
  end

  def _get_dataset(path)

    datasetstring = path.split("/")[1]

    Dataset.find(datasetstring.split("-").first)

  end

  def _get_subpath(path)

    elements = path.split("/")

    res = []

    if elements.count > 2 then 

      res = elements[2..-1]

      return res.join("/")+"/"

    end

    return ""
  end

  def _get_subpathoffile(path)

    elements = path.split("/")

    res = []

    if elements.count > 3 then 

      res = elements[2..-2]

      return res.join("/")+"/"

    end

    return ""
  end

  def _get_file(path)

    elements = path.split("/")

    res = elements[-1]

    return res
  end


  def ds_children(dataset, pathfilter)

    res = []

    dataset.uniquefolders?.each do |uf|

      if uf.starts_with?(pathfilter) then

        # if it's the next level, display it

        if uf[pathfilter.length..-1].split("/").length > 0 then

          nextlevel = uf[pathfilter.length..-1].split("/")[0]

          if !nextlevel.in?(res) then

            res << nextlevel

          end

        end
      end

    end

    dataset.attachments.map do |at|

      checkfolder = at.folder?

        if pathfilter == checkfolder then 

          res << at.filename?

        end

    end

    res
  end

end