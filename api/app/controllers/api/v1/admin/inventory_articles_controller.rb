class Api::V1::Admin::InventoryArticlesController < Api::V1::ApiController
  before_action :require_admin

  def index
    render json: current_inventory.inventory_articles,
           root: 'data'
  end

  def create
    inventory_article = current_inventory.inventory_articles.build(inventory_articles_params)

    if inventory_article.save
      render json: inventory_article
    else
      raise Errors::BadRequest.new(inventory_article.errors.full_messages)
    end
  end

  def update
    if inventory_article.update_attributes(inventory_articles_params)
      render json: inventory_article
    else
      raise Errors::BadRequest.new(inventory_article.errors.full_messages)
    end
  end

  def destroy
    if inventory_article.destroy
      render json: inventory_article
    else
      raise Errors::General
    end
  end

  private

    def inventory_articles_params
      params.require(:inventory_article).permit(
        :article_id,
        :count
      )
    end

    def inventory_article
      @inventory_article ||= current_inventory.inventory_articles.find(params[:id])
    end
end
