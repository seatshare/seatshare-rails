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
    @entity_types = EntityType.order_by_sort
    @teams_list = {}
    @entity_types.each do |et|
      label = "#{et.entity_type_name} (#{et.entity_type_abbreviation})"
      @teams_list[label] = Entity.where(
        "entity_type_id = #{et.id}"
      ).active.order_by_name
    end
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
