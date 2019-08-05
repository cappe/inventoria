module Errors
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from Exception do
        respond(I18n.t('api.errors.general'), :internal_server_error)
      end

      rescue_from ActiveRecord::RecordNotFound do
        respond(I18n.t('api.errors.not_found'), :not_found)
      end

      rescue_from BadRequest do |e|
        respond(e.message, :bad_request)
      end
    end

    def respond(message, status)
      render json: { message: message }, status: status
    end
  end
end
