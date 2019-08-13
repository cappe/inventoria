module Errors
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from Exception do |e|
        respond(I18n.t('api.errors.general'), :internal_server_error, e)
      end

      rescue_from ActionController::ParameterMissing do |e|
        respond(I18n.t('api.errors.parameter_missing'), :unprocessable_entity, e)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        respond(I18n.t('api.errors.not_found'), :not_found, e)
      end

      rescue_from Errors::Base do |e|
        respond(e.message, e.status, e)
      end
    end

    def respond(message, status, e)
      Rails.logger.debug('====== ERROR ======'.red)
      Rails.logger.debug("status: #{status}".yellow)
      Rails.logger.debug("message: #{message}".yellow)
      Rails.logger.debug("error message: #{e.message}".yellow)
      Rails.logger.debug(e.backtrace.first(25).join("\n").red)
      Rails.logger.debug('====== ERROR ENDS ======'.red)


      render json: { message: message }, status: status
    end
  end
end
