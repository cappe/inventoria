module Errors
  class Unauthorized < Base
    def initialize
      super(I18n.t('api.errors.unauthorized'), :unauthorized)
    end
  end
end
