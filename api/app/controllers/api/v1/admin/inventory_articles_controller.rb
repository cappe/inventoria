class Api::V1::Admin::InventoryArticlesController < Api::V1::ApiController
  before_action :require_admin

  def replace_all
    article_ids = inventory_articles_params[:article_ids]

    result = Inventories::ReplaceAllInventoryArticles.call({
      current_inventory: current_inventory,
      article_ids: article_ids
    })

    if result.success?
      head :no_content
    else
      raise Errors::General
    end
  end

  private

    def inventory_articles_params
      params.require(:inventory_articles).permit(article_ids: [])
    end
end
