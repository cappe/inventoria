module Errors
  class NotFound < Base
    def initialize(message)
      super(message, :bad_request)
    end
  end
end
