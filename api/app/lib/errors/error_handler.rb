module Errors
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from Exception do |e|
        respond(I18n.t('api.errors.general'), :internal_server_error, e)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        respond(I18n.t('api.errors.not_found'), :not_found, e)
      end

      rescue_from BadRequest do |e|
        respond(e.message, :bad_request, e)
      end
    end

    def respond(message, status, e)
      Rails.logger.debug "e: #{e}".red

      render json: { message: message }, status: status
    end
  end
end
