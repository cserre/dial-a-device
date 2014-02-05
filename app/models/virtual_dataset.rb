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



  	  puts "webdav exist? "+file_path+ "("+request.env["HTTP_USER_AGENT"]+")"

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

   def _virtualfile?(path)

    res = false

    ds = _get_dataset(path)

      ds.attachments.each do |at|

        if ("/"+at.folder?).starts_with?("/"+_get_subpath(path)) then 
          res = true
        end
      end

    return res
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

  def _get_file(path)

    elements = path.split("/")

    res = elements[-1]

    return res
  end

  
  def _subdirectory?(path)

    res = false

    if !_root?(path) && !_virtualdataset?(path) then 


      ds = _get_dataset(path)

      ds.attachments.each do |at|

        if (at.folder?).starts_with?(get_subpath(path)) then 
          res = true
        end
      end
      # if attachments exist with _get_subpath(path) is folder? then res = true end
     
    end

    puts res

    res
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