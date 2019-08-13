class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin13,
             :gtin14,
             :unit

  attribute :saldo, if: -> { should_include?(:saldo) }
  attribute :saldo_total, if: -> { responds_to?(:saldo_total) }
  attribute :products, if: -> { should_include?(:products) }

  def saldo
    object.article.products.length
  end

  def products
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      each_serializer: Api::V1::ProductSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.article.products, options)
      .as_json
  end
end
