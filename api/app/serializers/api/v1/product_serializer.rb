class Api::V1::ProductSerializer < ApplicationSerializer
  attributes :id,
             :gtin,
             :lot,
             :manufacture_date,
             :expiry_date,
             :used,
             :used_at
end
