class SessionsController < Devise::SessionsController
  respond_to :html, :json

  def new
	@is_ajax = !request.headers["X-Requested-With"].nil? && request.headers["X-Requested-With"] == "XMLHttpRequest"
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource)) 
  end
end