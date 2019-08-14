class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :require_admin, except: [:index, :with_products]

  def index
    render json: Article.all,
           root: 'data'
  end

  def with_products
    articles = current_inventory.inventory_articles
      .joins(:article)
      .select(
        'articles.id AS id',
        :name,
        :pid,
        :gtin13,
        :gtin14,
        :unit,
        'count AS saldo_total',
        'articles.id AS article_id'
      )
      .includes(article: [:products])

    render json: articles,
           root: 'data',
           includes: [:products, :saldo],
           each_serializer: Api::V1::ArticleSerializer
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
