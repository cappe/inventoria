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
    user = object.user

    unless user
      user = User.new
      user.id = -1
      user.email = 'Poistettu käyttäjä'
    end

    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      serializer: Api::V1::UserForAuditSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(user, options)
      .as_json
  end
end
