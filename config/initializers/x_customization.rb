LsiRailsPrototype::Application.configure do

  config.application_name = "dial-a-device"

  config.datasetroot = "#{Rails.root}/tmp/storage/"

end

module LsiRailsPrototype
  class Application < Rails::Application
  	    config.action_mailer.default_url_options = { :host => 'www.dial-a-device.net'}

  end
end


Devise.setup do |config|

  config.mailer_sender = 'mail@dial-a-device.net'

end