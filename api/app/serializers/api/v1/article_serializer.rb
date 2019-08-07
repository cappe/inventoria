class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin13,
             :gtin14,
             :unit

  attribute :belongs_to_inventory, if: -> { should_include?(:belongs_to_inventory) }
end
