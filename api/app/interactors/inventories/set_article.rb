module Inventories
  class SetArticle
    include Interactor

    def call
      gtin = context.product_params[:gtin]

      article = Article
                  .where(gtin13: gtin)
                  .or(Article.where(gtin14: gtin))
                  .first

      if article
        context.article = article
      else
        context.fail!(error: I18n.t('inventory.article_not_found'))
      end
    end
  end
end
