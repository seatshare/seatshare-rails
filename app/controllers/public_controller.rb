class PublicController < ApplicationController

  layout :layout_by_resource
  before_action :authenticate_user!, only: :token

  def index
    if user_signed_in?
      if session[:current_group_id].is_a? Numeric
        redirect_to :controller => 'groups', :action => 'show', :id => session[:current_group_id], :status => 302 and return
      else
        groups = Group.get_groups_by_user_id(current_user.id)
        if groups.blank?
          redirect_to :controller => 'groups', :action => 'index', :status => 302 and return
        else
          redirect_to :controller => 'groups', :action => 'show', :id => groups.first.id, :status => 302 and return
        end
      end
    end
    @page_title = %q{Welcome to SeatShare}
    @meta_description = %q{SeatShare helps you manage your group's season tickets for sporting or performing arts events. Sign up for free.}
  end

  def tos
    @page_title = %q{Terms of Service - SeatShare}
    @meta_description = %q{The Terms of Service for SeatShare are the rules that govern access and use of the website.}
  end

  def privacy
    @page_title = %q{Privacy Policy - SeatShare}
    @meta_description = %q{SeatShare values your privacy and will not sell or share your information.}
  end

  def contact
    @page_title = %q{Contact - SeatShare}
    @meta_description = %q{Have questions or comments about SeatShare? We are here to help.}
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
