class Api::V1::ProductsController < Api::V1::ApiController
  include IncludeParams

  def index
    includes = parse_include_params(:article)

    products = current_inventory.products.includes(includes)

    if ActiveModel::Type::Boolean.new.cast(params[:used])
      products = products.used
    end

    render json: products,
           root: 'data',
           includes: includes
  end
end
