class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin13,
             :gtin14,
             :unit

  attribute :products, if: -> { should_include?(:products) }

  def products
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      each_serializer: Api::V1::ProductSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.products, options)
      .as_json
  end
end
