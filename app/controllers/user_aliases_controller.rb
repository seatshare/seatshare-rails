class UserAliasesController < ApplicationController
  before_action :authenticate_user!
  layout 'two-column'

  def new
    @user_alias = UserAlias.new
  end

  def create
    user_alias = UserAlias.new(
      first_name: user_alias_params[:first_name],
      last_name: user_alias_params[:last_name],
      user_id: current_user.id
    )
    user_alias.save!
    flash.keep
    flash[:notice] = 'User alias created!'
    redirect_to(controller: 'profiles', action: 'edit') && return
  end

  def edit
    @user_alias = UserAlias.find_by_id(params[:id]) || not_found
    if @user_alias.user_id != current_user.id
      redirect_to(controller: 'profiles', action: 'edit') && return
    end
  end

  def update
    user_alias = UserAlias.find_by_id(params[:id]) || not_found
    user_alias.first_name = user_alias_params[:first_name]
    user_alias.last_name = user_alias_params[:last_name]
    user_alias.save!
    flash.keep
    flash[:notice] = 'User Alias updated!'
    redirect_to(controller: 'profiles', action: 'edit') && return
  end

  def delete
    user_alias = UserAlias.find_by_id(params[:id]) || not_found
    if user_alias.user_id != current_user.id
      redirect_to(controller: 'profiles', action: 'edit') && return
    end
    user_alias.destroy
    flash.keep
    flash[:notice] = 'User Alias deleted.'
    redirect_to(controller: 'profiles', action: 'edit') && return
  end

  private

  def user_alias_params
    params.require(:user_alias).permit(:first_name, :last_name, :user_id)
  end
end
