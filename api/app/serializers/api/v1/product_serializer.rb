class Api::V1::ProductSerializer < ApplicationSerializer
  attributes :id,
             :gtin,
             :lot,
             :manufacture_date,
             :expiry_date,
             :used,
             :used_at

  attribute :article, if: -> { should_include?(:article) }
end
