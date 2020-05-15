class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def new
	@is_ajax = !request.headers["X-Requested-With"].nil? && request.headers["X-Requested-With"] == "XMLHttpRequest"
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  def after_update_path_for(resource)
    sign_in_after_change_password? ? edit_user_registration_path : new_session_path(resource_name)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || blacklight.search_history_path
  end
end