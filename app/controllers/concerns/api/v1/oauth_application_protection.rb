# frozen_string_literal: true

module API
  module V1
    module OauthApplicationProtection
      extend ActiveSupport::Concern
      include API::V1::ErrorHandler

      included do
        skip_before_action :verify_authenticity_token
        before_action :verify_oauth_application
      end

      private

      def verify_oauth_application
        return if Doorkeeper::Server.new(self).client

        error_description = I18n.t('doorkeeper.errors.messages.invalid_client')

        render_error(detail: error_description, code: :invalid_client, status: :forbidden)
      end
    end
  end
end
