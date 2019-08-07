class Api::V1::Admin::InventoriesController < Api::V1::ApiController
  before_action :require_admin

  def index
    render json: Inventory.all, root: 'data'
  end

  def show
    render json: Inventory.find(params[:id])
  end
end
