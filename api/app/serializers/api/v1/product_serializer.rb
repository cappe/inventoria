class Api::V1::ProductSerializer < ApplicationSerializer
  attributes :id,
             :gtin,
             :lot,
             :manufacture_date,
             :expiry_date,
             :used,
             :used_at

  attribute :article, if: -> { should_include?(:article) }

  def article
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      serializer: Api::V1::ArticleSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.article, options)
      .as_json
  end
end
