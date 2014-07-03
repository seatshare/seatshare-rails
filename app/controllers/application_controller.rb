class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_filter :load_shared_interface_variables, if: :user_signed_in?

  layout :layout_by_resource

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def load_shared_interface_variables
    @group_selector = Group.get_groups_by_user_id(current_user.id).collect {|p| [ p.group_name, p.id ] }
  end

  def configure_devise_permitted_parameters

    registration_params = [:first_name, :last_name, :email, :password, :password_confirmation, :newsletter_signup, :invite_code]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end

  def layout_by_resource
    if devise_controller?
      if params[:controller] === 'devise/sessions' || params[:controller] === 'devise/passwords'
        "login"
      else
        "two-column"
      end
    else
      "application"
    end
  end

end