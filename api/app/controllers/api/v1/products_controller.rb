class Api::V1::ProductsController < Api::V1::ApiController
  include IncludeParams

  def allow_product_usage
    includes = parse_include_params(:article)

    result = Inventories::AllowProductUsage.call(
      current_inventory: current_inventory,
      datamatrix: params[:datamatrix]
    )

    if result.success?
      render json: result.product,
             includes: includes
    else
      render json: { message: result.error }, status: :bad_request
    end
  end
end
