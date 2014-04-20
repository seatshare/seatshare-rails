class UserAliasesController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column'

  def new
    @user_alias = UserAlias.new
    @page_title = 'Add User Alias'
  end

  def create
    user_alias = UserAlias.new({
      first_name: user_alias_params[:first_name],
      last_name: user_alias_params[:last_name],
      user_id: current_user.id
    })
    user_alias.save!
    flash[:success] = 'User Alias created!'
    redirect_to :controller => 'profiles', :action => 'edit' and return
  end

  def edit
    @user_alias = UserAlias.find_by_id(params[:id]) || not_found
    if @user_alias.user_id != current_user.id
      redirect_to :controller => 'profiles', :action => 'edit' and return
    end
    @page_title = 'Edit User Alias'
  end

  def update
    user_alias = UserAlias.find_by_id(params[:id]) || not_found
    user_alias.first_name = user_alias_params[:first_name]
    user_alias.last_name = user_alias_params[:last_name]
    user_alias.save!
    flash[:success] = 'User Alias updated!'
    redirect_to :controller => 'profiles', :action => 'edit' and return
  end

  def delete
    user_alias = UserAlias.find_by_id(params[:id]) || not_found
    if user_alias.user_id != current_user.id
      redirect_to :controller => 'profiles', :action => 'edit' and return
    end
    user_alias.destroy
    redirect_to :controller => 'profiles', :action => 'edit' and return
  end

  private

  def user_alias_params
    params.require(:user_alias).permit(:first_name, :last_name, :user_id)
  end

end
