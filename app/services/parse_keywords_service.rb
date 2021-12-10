# frozen_string_literal: true

class ParseKeywordsService
  def initialize(keywords_file)
    @keywords_file = keywords_file
  end

  def call
    csv_data = CSV.read(keywords_file.path)
    csv_data.map(&:first)
  rescue StandardError
    false
  end

  private

  attr_reader :keywords_file
end
