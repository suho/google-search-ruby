# frozen_string_literal: true

module API
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include API::V1::ErrorHandler

      skip_before_action :verify_authenticity_token
      before_action :verify_oauth_application

      def create
        super do |user|
          if user.persisted?
            head :created
          else
            render_error(detail: user.errors.full_messages.to_sentence)
          end
          return
        end
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
