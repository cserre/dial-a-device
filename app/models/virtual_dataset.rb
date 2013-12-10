require 'dav4rack/resources/file_resource'

class VirtualDataset < DAV4Rack::FileResource

  def root
    File.join(options[:root].to_s)
  end

  private
  
   def authenticate(username, password)
      self.user = User.where(["email = ?", username]).first
      user.try(:valid_password?, password)
   end  
    

end