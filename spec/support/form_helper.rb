# frozen_string_literal: true

module Form
  module FileHelpers
    def save_file(file_path)
      if file_path
        file = file_fixture(file_path)
        file_content_type = Rack::Mime::MIME_TYPES[file.extname]
        file = Rack::Test::UploadedFile.new(file, file_content_type)
      else
        file = nil
      end
      form = KeywordsForm.new(Fabricate(:user))
      form.save(file)
      form
    end
  end
end

RSpec.configure do |config|
  config.include Form::FileHelpers, type: :form
end
