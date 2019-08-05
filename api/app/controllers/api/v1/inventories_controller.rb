class Api::V1::InventoriesController < Api::V1::ApiController
  def place_product
    result = Inventories::PlaceProductToInventory.call(
      current_user: current_user,
      product_params: product_params
    )

    if result.success?
      render json: result.product
    else
      render json: { message: result.error }, status: :bad_request
    end
  end

  def use_product

  end

  private

    def product_params
      params.require(:product).permit(
        :gtin,
        :lot,
        :manufacture_date,
        :expiry_date
      )
    end
end