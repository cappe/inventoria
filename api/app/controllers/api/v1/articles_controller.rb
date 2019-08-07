class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :require_admin, except: [:index]

  def index
    unless params[:belongs_to_inventory]
      render json: Article.all,
             root: 'data'

      return
    end

    inventory_id = params[:belongs_to_inventory]

    # Using subquery here so that Rails can do its magic on sanitazing the inventory_id
    subquery = InventoryArticle
                 .where('article_id = articles.id')
                 .where(inventory_id: inventory_id)
                 .select(:id)
                 .to_sql

    articles = Article
                 .select(
                   "articles.*",
                   "EXISTS (#{subquery}) AS belongs_to_inventory"
                 )

    render json: articles,
           root: 'data',
           includes: [:belongs_to_inventory]
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
    @article ||= Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(
      :name,
      :pid,
      :gtin13,
      :gtin14,
      :unit
    )
  end
end
