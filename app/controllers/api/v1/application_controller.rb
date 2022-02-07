# frozen_string_literal: true

module API
  module V1
    class ApplicationController < ActionController::API
      include API::V1::DoorkeeperAuthentication
      rescue_from ActiveRecord::RecordNotFound, Pagy::OverflowError, with: :show_not_found_error

      private

      def show_not_found_error
        render status: :not_found
      end
    end
  end
end
