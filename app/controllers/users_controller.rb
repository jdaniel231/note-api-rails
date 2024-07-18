class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER
  def create
    if valid_email?(params[:username])
      @user = User.new(user_params)
      @user.role ||= 'client' # Definir valor padrão para role
      if @user.save
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    else
      render json: {error: "Invalid email format"}
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:username, :password, :age, :role)
  end

  def valid_email?(email)
    /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.match?(email)
  end
end
