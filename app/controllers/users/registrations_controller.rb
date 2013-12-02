class Users::RegistrationsController < Devise::RegistrationsController

	before_filter :configure_permitted_parameters

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) do |u|
			u.permit(:firstname, :lastname, :sign, :email, :password, :password_confirmation, 

				affiliations_attributes: [:country_title, :organization_title, :department_title, :group_title]
				)
		end

		devise_parameter_sanitizer.for(:account_update) do |u|
			u.permit(:firstname, :lastname, :sign, :email, :password, :password_confirmation, 

				affiliations_attributes: [:country_title, :organization_title, :department_title, :group_title]
				)
		end
	end
end