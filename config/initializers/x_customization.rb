LsiRailsPrototype::Application.configure do

  config.application_name = "LSI"

  config.action_mailer.default_url_options = { :host => 'lsi-rails-prototype.herokuapp.com'}

  config.mailer_sender = 'mail@lsi-rails-prototype.herokuapp.com'

end