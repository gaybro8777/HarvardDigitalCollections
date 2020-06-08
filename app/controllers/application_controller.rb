class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  protect_from_forgery with: :exception

  layout :layout_by_resource

  def layout_by_resource
	layout_setting = "blacklight"
    if (devise_controller? && resource_name == :user && action_name == 'new') || (is_a?(::ListsController) && action_name == 'edit')
      if !request.headers["X-Requested-With"].nil? && request.headers["X-Requested-With"] == "XMLHttpRequest"
		layout_setting = false
	  end
    end
	layout_setting
  end

  protected

  def after_sign_in_path_for(resource)
    "/catalog?search_field=all_fields&q="
  end

  def after_sign_out_path_for(resource)
    "/catalog?search_field=all_fields&q="
  end
end
