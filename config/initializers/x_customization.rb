LsiRailsPrototype::Application.configure do

  config.application_name = "LSI"

end

module LsiRailsPrototype
  class Application < Rails::Application
  	    config.action_mailer.default_url_options = { :host => 'lsi-rails-prototype.herokuapp.com'}

  end
end


Devise.setup do |config|

  config.mailer_sender = 'mail@lsi-rails-prototype.herokuapp.com'

end