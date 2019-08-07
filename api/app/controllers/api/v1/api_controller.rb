class Api::V1::ApiController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Errors::ErrorHandler

  # Add a before_action to authenticate all requests.
  # Move this to subclassed controllers if you only
  # want to authenticate certain methods.
  before_action :authenticate

  protected

    def current_inventory
      if current_user.admin?
        @current_inventory ||= Inventory.find(params[:inventory_id])
      else
        @current_inventory ||= current_user.inventory
      end
    end

    # Authenticate the user with token based authentication
    def authenticate
      authenticate_token || render_unauthorized
    end

    def require_admin
      current_user.admin? || render_unauthorized
    end

    def current_user
      @current_user
    end

    def authenticate_token
      authenticate_with_http_token do |token, options|
        user = User.find_by(access_token: token)

        if user && ActiveSupport::SecurityUtils.secure_compare(user.access_token, token)
          @current_user = user
        end
      end
    end

    def render_unauthorized
      raise Errors::Unauthorized.new
    end
end
