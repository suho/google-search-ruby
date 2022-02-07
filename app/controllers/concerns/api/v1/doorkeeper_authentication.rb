# frozen_string_literal: true

module API
  module V1
    module DoorkeeperAuthentication
      extend ActiveSupport::Concern
      include API::V1::ErrorHandler

      included do
        before_action :doorkeeper_authorize!
      end

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def doorkeeper_unauthorized_render_options(error: nil)
        return unless error

        {
          json: {
            errors: build_errors(detail: error.description, source: error.state, code: error.name)
          }
        }
      end
    end
  end
end
