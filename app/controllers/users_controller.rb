##
# Users controller
class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'two-column'

  ##
  # Show a user profile
  def show
    @user = User.find_by_id(params[:id]) || current_user
    not_found unless current_user.user_can_view? @user
  end

  ##
  # Edit the current user's profile
  def edit
    @user = current_user
    @user_aliases = current_user.user_aliases.by_name
  end

  ##
  # Process the edits for current user's profile
  def update
    user = current_user
    user.update_attributes!(user_params)

    flash.keep
    flash[:notice] = 'Profile updated!'
    redirect_to(action: :show, id: @current_user.id) && return
  end

  private

  ##
  # Strong parameters for user profile
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :timezone, :bio, :location, :mobile, :sms_notify
    )
  end
end
