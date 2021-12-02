# frozen_string_literal: true

class ParseKeywordsService

  def initialize(keywords_file)
    @keywords_file = keywords_file
  end

  def call
    csv_data = CSV.read(@keywords_file.path)
    csv_data.map(&:first)
  rescue StandardError
    raise GoogleSearch::Errors::KeywordsError, I18n.t('keywords.upload.invalid_file')
  end
end
