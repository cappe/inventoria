module Inventories
  class PlaceProductToInventory
    include Interactor::Organizer

    organize SetArticle,
             BuildProduct,
             FindExistingProduct,
             CheckIfProductIsPlacedAlready,
             CheckIfProductIsUsed,
             SaveProduct
  end
end
