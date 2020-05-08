class RegistrationsController < Devise::RegistrationsController
  def after_update_path_for(resource)
    sign_in_after_change_password? ? edit_user_registration_path : new_session_path(resource_name)
  end
end