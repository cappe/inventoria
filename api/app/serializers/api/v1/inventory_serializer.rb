class Api::V1::InventorySerializer < ApplicationSerializer
  attributes :id,
             :name,
             :deliver_orders_every
end
