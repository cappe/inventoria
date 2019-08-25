class Api::V1::ProductsController < Api::V1::ApiController
  include IncludeParams

  def show
    includes = parse_include_params(:article)

    if product
      render json: product,
             includes: includes
    else
      raise Errors::NotFound, I18n.t('inventory.product_is_missing')
    end
  end

  private

    def product
      @product ||= current_inventory
                     .products
                     .not_used
                     .find_by(datamatrix: params[:datamatrix])
    end
end
