class Api::V1::Admin::InventoriesController < Api::V1::ApiController
  before_action :require_admin

  def index
    render json: Inventory.all, root: 'data'
  end

  def show
    render json: inventory
  end

  def create
    inventory = Inventory.new(inventory_params)

    if inventory.save
      render json: inventory
    else
      raise Errors::BadRequest.new(inventory.errors.full_messages)
    end
  end

  def update
    if inventory.update_attributes(inventory_params)
      render json: inventory
    else
      raise Errors::BadRequest.new(inventory.errors.full_messages)
    end
  end

  def destroy
    if inventory.destroy
      render json: inventory
    else
      if inventory.errors.full_messages.length > 0
        raise Errors::BadRequest.new(inventory.errors.full_messages)
      end

      raise Errors::General
    end
  end

  private

    def inventory
      @inventory ||= Inventory.find(params[:id])
    end

    def inventory_params
      params.require(:inventory).permit(:name)
    end
end
