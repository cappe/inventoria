module Errors
  class BadRequest < Base
    def initialize(message)
      if message.is_a?(Array)
        message = message.join(', ')
      end

      super(message, :bad_request)
    end
  end
end
