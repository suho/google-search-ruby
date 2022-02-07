# frozen_string_literal: true

module API
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include API::V1::OauthApplicationProtection

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
    end
  end
end
