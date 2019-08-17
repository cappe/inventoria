class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :require_admin, except: [:index, :with_products, :show]

  def index
    render json: Article.all,
           root: 'data'
  end

  def with_products
    inventory_articles = current_inventory.inventory_articles
    products = current_inventory.products

    article_ids = []

    article_ids.concat(products.all.map(&:article_id))
    article_ids.concat(inventory_articles.all.map(&:article_id))

    articles = Article
                 .where(id: article_ids)
                 .includes([
                   :products,
                   :inventory_articles
                 ])
                 .references(:products)

    render json: articles,
           root: 'data',
           includes: [
             :products,
             :saldo,
             :saldo_total,
             :is_commission_product
           ],
           each_serializer: Api::V1::ArticleSerializer
  end

  def show
    render json: article
  end

  def create
    article = Article.new(article_params)

    if article.save
      render json: article
    else
      raise Errors::BadRequest.new(article.errors.full_messages)
    end
  end

  def update
    if article.update_attributes(article_params)
      render json: article
    else
      raise Errors::BadRequest.new(article.errors.full_messages)
    end
  end

  def destroy
    if article.destroy
      render json: article
    else
      if article.errors.full_messages.length > 0
        raise Errors::BadRequest.new(article.errors.full_messages)
      end

      raise Errors::General
    end
  end

  private

  def article
    if params[:gtin]
      @article ||= Article.find_by!(gtin: params[:gtin])
    else
      @article ||= Article.find(params[:id])
    end
  end

  def article_params
    params.require(:article).permit(
      :name,
      :pid,
      :gtin,
      :unit
    )
  end
end
