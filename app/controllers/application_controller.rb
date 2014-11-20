class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :load_shared_interface_variables, if: :user_signed_in?
  before_filter :set_timezone, if: :user_signed_in?

  layout :layout_by_resource

  def not_found
    not_found_message = ActionController::RoutingError.new('Not Found')
    fail not_found_message
  end

  protected

  def load_shared_interface_variables
    @group_selector = current_user.groups.order_by_name.active.collect do|p|
      [p.group_name, p.id]
    end
  end

  def configure_devise_permitted_parameters
    registration_params = [
      :first_name, :last_name, :email, :password, :password_confirmation,
      :newsletter_signup, :invite_code, :entity_id
    ]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) do
        |u| u.permit(registration_params << :current_password)
      end
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) do
        |u| u.permit(registration_params)
      end
    end
  end

  def layout_by_resource
    if devise_controller?
      if ['devise/sessions', 'devise/sessions'].include? params[:controller]
        'login'
      else
        'two-column'
      end
    else
      'application'
    end
  end

  private

  def set_timezone
    tz = current_user ? current_user.timezone : nil
    if tz.blank?
      Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']
    else
      Time.zone = tz
    end
  end
end
