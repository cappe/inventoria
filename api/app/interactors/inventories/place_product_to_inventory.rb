module Inventories
  class PlaceProductToInventory
    include Interactor::Organizer

    before do
      context.current_inventory = context.current_user.inventory
    end

    organize SetArticle, AddToInventory#, CreateEventLog
  end
end
