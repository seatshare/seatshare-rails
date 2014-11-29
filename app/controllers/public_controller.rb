class PublicController < ApplicationController
  layout :layout_by_resource
  before_action :authenticate_user!, only: :token

  def index
    render 'index' && return unless user_signed_in?
    if session[:current_group_id].is_a? Numeric
      redirect_to(
        controller: 'groups', action: 'show',
        id: session[:current_group_id], status: 302
      ) && return
    else
      redirect_to_default_group
    end
  end

  def teams
    @teams_nfl = Entity.where('entity_type_id = 4').active.order_by_name
    @teams_mlb = Entity.where('entity_type_id = 2').active.order_by_name
    @teams_nba = Entity.where('entity_type_id = 3').active.order_by_name
    @teams_nhl = Entity.where('entity_type_id = 1').active.order_by_name
    @teams_ncaaf = Entity.where('entity_type_id = 7').active.order_by_name
    @teams_ncaamb = Entity.where('entity_type_id = 8').active.order_by_name
    @teams_cfl = Entity.where('entity_type_id = 6').active.order_by_name
    @teams_mls = Entity.where('entity_type_id = 5').active.order_by_name
    @teams_wftda = Entity.where('entity_type_id = 9').active.order_by_name
  end

  def tos
  end

  def privacy
  end

  def contact
  end

  private

  def layout_by_resource
    if params[:action] == 'index'
      'home'
    else
      'two-column'
    end
  end

  def redirect_to_default_group
    groups = current_user.groups.active
    if groups.count == 0
      redirect_to(
        controller: 'groups', action: 'index', status: 302
      ) && return
    else
      redirect_to(
        controller: 'groups', action: 'show', id: groups.first.id,
        status: 302
      ) && return
    end
  end
end
