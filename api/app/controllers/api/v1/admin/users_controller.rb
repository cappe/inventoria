class Api::V1::Admin::UsersController < Api::V1::ApiController
  before_action :require_admin

  def index
    render json: current_inventory.users,
           root: 'data',
           each_serializer: Api::V1::UserForAuditSerializer
  end

  def create
    user = current_inventory.users.build(user_params)

    if user.save
      render json: user,
             serializer: Api::V1::UserForAuditSerializer
    else
      raise Errors::BadRequest.new(user.errors.full_messages)
    end
  end

  def update
    if user.update_attributes(user_params)
      render json: user,
             serializer: Api::V1::UserForAuditSerializer
    else
      raise Errors::BadRequest.new(user.errors.full_messages)
    end
  end

  def destroy
    if user.destroy
      render json: user,
             serializer: Api::V1::UserForAuditSerializer
    else
      if user.errors.full_messages.length > 0
        raise Errors::BadRequest.new(user.errors.full_messages)
      end

      raise Errors::General
    end
  end

  private

    def user
      @user ||= current_inventory.users.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email)
    end
end
