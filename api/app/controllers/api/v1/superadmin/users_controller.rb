class Api::V1::Superadmin::UsersController < Api::V1::ApiController
  before_action :require_superadmin

  def index
    render json: User.admins,
           root: 'data'
  end

  def create
    admin_params = user_params
                     .merge({ role: :admin })

    user = User.new(admin_params)

    if user.save
      UserMailer.send_credentials_email(user).deliver_now

      render json: user
    else
      raise Errors::BadRequest.new(user.errors.full_messages)
    end
  end

  def update
    if user.update_attributes(user_params)
      render json: user
    else
      raise Errors::BadRequest.new(user.errors.full_messages)
    end
  end

  def destroy
    if user.destroy
      render json: user
    else
      if user.errors.full_messages.length > 0
        raise Errors::BadRequest.new(user.errors.full_messages)
      end

      raise Errors::General
    end
  end

  private

    def user
      @user ||= User.admins.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email)
    end
end
