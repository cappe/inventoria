class Api::V1::AuditsController < Api::V1::ApiController
  def by_inventory
    render json: current_inventory.products.audits
  end
end
