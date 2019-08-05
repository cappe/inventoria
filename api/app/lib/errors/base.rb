module Errors
  class Base < StandardError
    attr_reader :message,
                :status

    def initialize(message = I18n.t('api.errors.general'), status = 500)
      @message = message
      @status = status
    end
  end
end
