class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    @user = User.find_by(username: session_params[:username])
    if @user && @user.authenticate(session_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { token: token, username: @user.username, role: @user.role }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
