class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin,
             :unit

  attribute :saldo, if: -> { should_include?(:saldo) }
  attribute :saldo_total, if: -> { should_include?(:saldo_total) }
  attribute :products, if: -> { should_include?(:products) }
  attribute :is_commission_product, if: -> { should_include?(:is_commission_product) }

  def products
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      each_serializer: Api::V1::ProductSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(products_not_used, options)
      .as_json
  end

  def saldo
    products_not_used.length
  end

  def saldo_total
    return 0 unless object.inventory_articles.length > 0

    object.inventory_articles.first.count
  end

  def is_commission_product
    saldo_total > 0
  end

  private

    def products_not_used
      @products_not_used ||= object.products.select { |p| !p.used? }
    end
end
