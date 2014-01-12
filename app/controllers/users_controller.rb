class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:username])
    flash.now[:error] = ['Sorry User not found..'] unless @user.present?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_or_create_by_access_token(params[:user])
    if @user.errors.empty?
      redirect_to show_user_path(@user.username)
    else
      redirect_to root_url, flash: {error: @user.errors.full_messages}
    end
  end
end
