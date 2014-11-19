class PublicController < ApplicationController

  layout :layout_by_resource
  before_action :authenticate_user!, only: :token

  def index
    if user_signed_in?
      if session[:current_group_id].is_a? Numeric
        redirect_to(
          :controller => 'groups', :action => 'show',
          :id => session[:current_group_id], :status => 302
        ) and return
      else
        groups = current_user.groups.active
        if groups.count == 0
          redirect_to(
            :controller => 'groups', :action => 'index', :status => 302
          ) and return
        else
          redirect_to(
            :controller => 'groups', :action => 'show', :id => groups.first.id,
            :status => 302
          ) and return
        end
      end
    end
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
  end

  def tos
  end

  def privacy
  end

  def contact
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
