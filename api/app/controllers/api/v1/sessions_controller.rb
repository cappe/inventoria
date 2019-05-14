class Api::V1::SessionsController < Api::V1::ApiController
  before_action :authenticate, except: :create

  def show
    render json: current_user
  end

  def create
    session_params = params[:session]

    if session_params.dig(:email).nil? || session_params.dig(:password).nil?
      raise Exception
    end

    user = User.find_by(email: session_params[:email].downcase)

    unless user && user.authenticate(session_params[:password])
      raise Exception
    end

    user.regenerate_access_token

    render json: user
  end

  def destroy
    current_user.regenerate_access_token

    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
