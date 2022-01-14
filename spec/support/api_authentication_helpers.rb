# frozen_string_literal: true

RSpec.configure do
  def oauth_application_params(application = Fabricate(:doorkeeper_application))
    {
      client_id: application.uid,
      client_secret: application.secret
    }
  end
end
