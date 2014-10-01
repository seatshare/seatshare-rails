class PublicController < ApplicationController

  layout :layout_by_resource
  before_action :authenticate_user!, only: :token

  def index
    if user_signed_in?
      if session[:current_group_id].is_a? Numeric
        redirect_to :controller => 'groups', :action => 'show', :id => session[:current_group_id], :status => 302 and return
      else
        groups = current_user.groups.active
        if groups.count == 0
          redirect_to :controller => 'groups', :action => 'index', :status => 302 and return
        else
          redirect_to :controller => 'groups', :action => 'show', :id => groups.first.id, :status => 302 and return
        end
      end
    end
    @page_title = %q{Welcome to SeatShare}
    @meta_description = %q{SeatShare helps you manage your group's season tickets for sporting or performing arts events. Sign up for free.}
  end

  def teams
    @teams_nfl = Entity.where("entity_type = 'NFL'").active.order_by_name
    @teams_mlb = Entity.where("entity_type = 'MLB'").active.order_by_name
    @teams_nba = Entity.where("entity_type = 'NBA'").active.order_by_name
    @teams_nhl = Entity.where("entity_type = 'NHL'").active.order_by_name
    @teams_ncaaf = Entity.where("entity_type = 'NCAAF'").active.order_by_name
    @teams_ncaamb = Entity.where("entity_type = 'NCAAMB'").active.order_by_name
    @teams_cfl = Entity.where("entity_type = 'CFL'").active.order_by_name
    @teams_mls = Entity.where("entity_type = 'MLS'").active.order_by_name
    @teams_wftda = Entity.where("entity_type = 'WFTDA'").active.order_by_name

    @page_title = %q{Manage Season Tickets for Your Favorite Team - SeatShare}
    @meta_description = %{We import scheduled for all of the most popular sports teams, including NHL, NFL, NBA, MLB and college sports.}
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

  def calculator
    @page_title = %q{SeatShare Calculator}
    @meta_description = %q{Calculate how many seats your season ticket investment would be worth}
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
