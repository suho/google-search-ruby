# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::ControllerHelpers, type: :request

  config.before(:each, devise_mapping: true) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
