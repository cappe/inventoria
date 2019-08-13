class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :require_admin, except: [:index]

  def index
    render json: Article.all,
           root: 'data'
  end

  def with_products
    articles = Article.with_products_in_inventory(current_inventory)

    render json: articles,
           root: 'data',
           includes: [:products]
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
