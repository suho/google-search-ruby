# frozen_string_literal: true

module API
  module V1
    class ApplicationController < ActionController::API
      include API::V1::DoorkeeperAuthentication
    end
  end
end
