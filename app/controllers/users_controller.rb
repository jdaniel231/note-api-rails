class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  # REGISTER

  def create
    if valid_email?(params[:username])
      @user = User.new(user_params)
      @user.role ||= 'client' # Definir valor padrão para role
      if @user.save
        token = encode_token({ user_id: @user.id, username: @user.username, role: @user.role })
        render json: { user: @user.as_json(only: [:username, :role]), token: token }
      else
        render json: { error: "Invalid username or password" }
      end
    else
      render json: { error: "Invalid email format" }
    end
  end


  # LOGGING IN
  def login
    @user = User.find_by(username: user_params[:username])
    if @user && @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id, username: @user.username, role: @user.role })
      render json: { user: @user.as_json(only: [:username, :role]), token: token }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
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
