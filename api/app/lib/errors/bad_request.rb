module Errors
  class BadRequest < Base
    def initialize(message)
      super(message, :bad_request)
    end
  end
end
