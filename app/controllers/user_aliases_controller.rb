##
# User Aliases class
class UserAliasesController < ApplicationController
  before_action :authenticate_user!
  layout 'two-column'

  ##
  # New user alias form
  def new
    @user_alias = UserAlias.new
  end

  ##
  # Process new user alias
  def create
    user_alias = UserAlias.new(
      first_name: user_alias_params[:first_name],
      last_name: user_alias_params[:last_name],
      user_id: current_user.id
    )
    flash.keep
    if user_alias.save
      flash[:notice] = 'User alias created!'
      redirect_to(controller: :users, action: :edit) && return
    else
      flash[:error] = 'Could not create User Alias.'
      redirect_to(controller: :user_aliases, action: :new) && return
    end
  end

  ##
  # Edit user alias form
  def edit
    @user_alias = UserAlias.find_by(id: params[:id]) || not_found
    redirect_to(
      controller: :users, action: :edit
    ) && return if @user_alias.user_id != current_user.id
  end

  ##
  # Process user alias updates
  def update
    user_alias = UserAlias.find_by(id: params[:id]) || not_found
    user_alias.first_name = user_alias_params[:first_name]
    user_alias.last_name = user_alias_params[:last_name]
    flash.keep
    if user_alias.save
      flash[:notice] = 'User Alias updated!'
      redirect_to(controller: :users, action: :edit) && return
    else
      flash[:error] = 'Could not update User Alias.'
      redirect_to(
        controller: :user_aliases, action: :edit, id: user_alias.id
      ) && return
    end
  end

  ##
  # Process a user alias delete
  def destroy
    user_alias = UserAlias.find_by(id: params[:id]) || not_found
    if user_alias.user_id != current_user.id
      redirect_to(controller: :users, action: :edit) && return
    end
    user_alias.destroy
    flash.keep
    flash[:notice] = 'User Alias deleted.'
    redirect_to(controller: :users, action: :edit) && return
  end

  private

  ##
  # Strong parameters for user aliases
  def user_alias_params
    params.require(:user_alias).permit(:first_name, :last_name, :user_id)
  end
end
