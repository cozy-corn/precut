class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # /users/sign_up
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :full_name, :gender, :age_group ])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      root_path
    else
      super # User以外の場合はDeviseのデフォルト処理に任せる
    end
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
end
