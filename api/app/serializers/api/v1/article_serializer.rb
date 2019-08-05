class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin13,
             :gtin14,
             :unit
end
