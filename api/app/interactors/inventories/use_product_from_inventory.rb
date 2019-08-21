module Inventories
  class UseProductFromInventory
    include Interactor::Organizer

    before do
      context.gtin = context.params[:gtin]
      context.lot = context.params[:lot]
      context.delivery_option = context.params[:delivery_option].underscore.to_sym
    end

    organize UseProduct, PlaceProductOrder
  end
end
