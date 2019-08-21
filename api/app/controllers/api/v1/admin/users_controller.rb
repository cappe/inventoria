class Api::V1::Admin::UsersController < Api::V1::ApiController
  before_action :require_admin

  def index
    render json: current_inventory.users,
           root: 'data'
  end

  def create
    user = current_inventory.users.build(user_params)

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
      if current_user.superadmin?
        @user ||= User.find(params[:id])
      else
        @user ||= current_inventory.users.find(params[:id])
      end
    end

    def user_params
      if current_user.superadmin?
        return params.require(:user).permit(:email, :receive_orders)
      end

      params.require(:user).permit(:email)
    end
end
