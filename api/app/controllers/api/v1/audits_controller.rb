class Api::V1::AuditsController < Api::V1::ApiController
  def by_inventory
    result = Audits::ReadProductAudits.call(
      current_inventory: current_inventory
    )

    if result.success?
      render json: result.product_audits, root: 'data'
    else
      render json: { message: I18n.t('api.errors.general') },
             status: :internal_server_error
    end
  end
end
