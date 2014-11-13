class ProfilesController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column'

  def show
    @user = User.find_by_id(params[:id]) || not_found
    if @user.profile.nil?
      @user.profile = Profile.new
    end
    @page_title = "#{@user.display_name}"
  end

  def edit
    @user = current_user
    if @user.profile.nil?
      @user.profile = Profile.new
    end
    @user_aliases = current_user.user_aliases
    @page_title = "Edit Profile"
  end

  def update
    user = current_user
    user.update_attributes!(user_params)

    flash.keep
    flash[:notice] = "Profile updated!"
    redirect_to :action => 'show', :id => @current_user.id and return
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :timezone, profile_attributes: [:bio, :location, :mobile, :sms_notify])
  end

end
