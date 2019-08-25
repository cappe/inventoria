module Inventories
  class AllowProductUsage
    include Interactor::Organizer

    organize SetProduct,
             CheckIfProductIsUsed,
             IsProductFirstToExpire
  end
end