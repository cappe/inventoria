module Inventories
  class PlaceProductToInventory
    include Interactor::Organizer

    organize SetArticle, AddToInventory#, CreateEventLog
  end
end
