class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find_by_id(params[:id]) || not_found
    @page_title = "#{@user.full_name}"
  end

  def edit
    @user = current_user
    @page_title = "Edit Profile"
  end

  def update
  end
end
