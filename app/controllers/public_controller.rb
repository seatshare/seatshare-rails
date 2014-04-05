class PublicController < ApplicationController

  layout :layout_by_resource
  before_action :authenticate_user!, only: :token

  def index
    if user_signed_in?
      if session[:current_group_id].is_a? Numeric
        redirect_to :controller => 'groups', :action => 'show', :id => session[:current_group_id], :status => 302
      else
        groups = Group.get_groups_by_user_id(current_user.id)
        if groups.blank?
          redirect_to :controller => 'groups', :action => 'index', :status => 302
        else
          redirect_to :controller => 'groups', :action => 'show', :id => groups.first.id, :status => 302
        end
      end
    end
  end

  def tos
    @page_title = 'Terms of Service'
  end

  def privacy
    @page_title = 'Privacy Policy'
  end

  def contact
    @page_title = 'Contact'
  end

  private

  def layout_by_resource
    if params[:action] === 'index'
      "home"
    else
      "two-column"
    end
  end

end
