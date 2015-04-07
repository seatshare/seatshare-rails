##
# Public controller
class PublicController < ApplicationController
  layout :layout_by_action
  before_action :authenticate_user!, only: :token

  ##
  # Home page
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

  ##
  # Teams page
  def teams
    @entity_types = EntityType.by_sort
    @teams_list = {}
    @entity_types.each do |et|
      label = "#{et.entity_type_name} (#{et.entity_type_abbreviation})"
      @teams_list[label] = Entity.where(
        "entity_type_id = #{et.id}"
      ).active.by_name
    end
  end

  ##
  # League page
  def league
    abbreviation = params[:entity_type_abbreviation].upcase || not_found
    @entity_types = EntityType.by_sort
    @entity_type = EntityType.where(
      ['entity_type_abbreviation = ?', abbreviation]
    ).first || not_found
    @entities = @entity_type.entities.active.by_name
  end

  ##
  # Terms of Service
  def tos
  end

  ##
  # Privacy policy
  def privacy
  end

  ##
  # Contact form
  def contact
  end

  private

  ##
  # Select a layout by method
  def layout_by_action
    if params[:action] == 'index'
      'home'
    elsif params[:action] == 'league'
      'single-column'
    else
      'two-column'
    end
  end

  ##
  # Redirect user to default group on index route
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
