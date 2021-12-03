# frozen_string_literal: true

module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module FileHelpers
    def keywords_file_params(file_name)
      path = Rails.root.join('spec', 'fixtures', 'files', file_name)
      file = Rack::Test::UploadedFile.new(path, 'text/csv')
      { keywords_file: file }
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Rails::ControllerExampleGroup, type: :request # required to have access to routes block
  config.include Request::JsonHelpers, type: :request
  config.include Request::FileHelpers, type: :request
end
