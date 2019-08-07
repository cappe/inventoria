module Inventories
  class UseProductFromInventory
    include Interactor::Organizer

    before do
      context.gtin = context.params[:gtin]
      context.lot = context.params[:lot]

      context.gtin.slice!(0) # Removes the first character
    end

    organize UseProduct
  end
end
