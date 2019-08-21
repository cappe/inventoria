module Inventories
  class UseProductFromInventory
    include Interactor::Organizer

    before do
      context.gtin = context.params[:gtin]
      context.lot = context.params[:lot]
    end

    organize UseProduct, PlaceProductOrder
  end
end
