# frozen_string_literal: true

module API
  module V1
    class PasswordsController < Devise::PasswordsController
      include API::V1::OauthApplicationProtection

      def create
        super do |user|
          if user.valid?
            render json: {
              meta: { message: t('devise.passwords.send_paranoid_instructions') }
            }
          else
            render_error(detail: user.errors.full_messages_for(:email).first)
          end

          return
        end
      end
    end
  end
end
