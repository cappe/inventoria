class Api::V1::ProductsController < Api::V1::ApiController
  include IncludeParams

  def index
    includes = parse_include_params(:article)

    render json: current_inventory.products.includes(includes),
           root: 'data',
           includes: includes
  end
end
