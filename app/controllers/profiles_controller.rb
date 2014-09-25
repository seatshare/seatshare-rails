class ProfilesController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column'

  def show
    @user = User.find_by_id(params[:id]) || not_found
    @page_title = "#{@user.display_name}"
  end

  def edit
    @user = current_user
    @user_aliases = current_user.user_aliases
    @page_title = "Edit Profile"
  end

  def update
    current_user.first_name = user_params[:first_name]
    current_user.last_name = user_params[:last_name]
    current_user.timezone = user_params[:timezone]
    current_user.save!
    flash.keep
    flash[:notice] = "Profile updated!"
    redirect_to :action => 'show', :id => @current_user.id and return
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :timezone)
  end

end
