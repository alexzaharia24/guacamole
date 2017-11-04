class UsersController < ApplicationController
  before_action :authenticate_user,  only: [:index, :current, :update]
  before_action :authorize_as_admin, only: [:destroy]
  before_action :authorize,          only: [:update]

  def current
    current_user.update!(last_login: Time.now)
    render json: current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { msg: 'User was created.' }, status: 200
    else
      render json: { error: user.errors.full_messages }, status: 400
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { msg: 'User details have been updated.' }, status: 200
    else
      render json: { error: user.errors.full_messages }, status: 400
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: { msg: 'User has been deleted.' }, status: 200
    else
      render json: { error: user.errors.full_messages }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize
    head :unauthorized unless current_user && current_user.can_modify_user?(params[:id])
  end
end
