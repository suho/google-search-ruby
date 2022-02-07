# frozen_string_literal: true

module APIAuthentication
  module OauthHelper
    def api_sign_in
      user = Fabricate(:user)
      application = Fabricate(:doorkeeper_application)
      access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
      allow(controller).to receive(:doorkeeper_token) { access_token }
      request.headers['Content-Type'] = 'application/json'

      user
    end
  end
end

RSpec.configure do |config|
  config.include APIAuthentication::OauthHelper, type: :request

  def oauth_application_params(application = Fabricate(:doorkeeper_application))
    {
      client_id: application.uid,
      client_secret: application.secret
    }
  end
end
