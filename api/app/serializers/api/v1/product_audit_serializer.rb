class Api::V1::ProductAuditSerializer < ApplicationSerializer
  attributes :id,
             :action,
             :comment,
             :created_at,
             :product,
             :article,
             :user

  def product
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      serializer: Api::V1::ProductSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.product, options)
      .as_json
  end

  def article
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      serializer: Api::V1::ArticleSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.article, options)
      .as_json
  end

  def user
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      serializer: Api::V1::UserForAuditSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(object.user, options)
      .as_json
  end
end
