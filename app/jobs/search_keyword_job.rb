# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :default

  def perform(keyword_id)
    @keyword = Keyword.find(keyword_id)
    begin
      html = GoogleSearchService.new(keyword: keyword.keyword).call
      parse_result = GoogleParseService.new(html: html).result
      save_data(html, parse_result)
    rescue ActiveRecord::RecordNotFound, GoogleSearch::Errors::SearchKeywordError, ActiveRecord::StatementInvalid
      keyword.update_status(:failed)
    end
  end

  private

  attr_reader :keyword

  def save_data(html, parse_result)
    Keyword.transaction do
      # rubocop:disable Rails::SkipsModelValidations
      keyword.links.insert_all(parse_result[:all_links])
      # rubocop:enable Rails::SkipsModelValidations
      keyword.update_data(html: html, parse_result: parse_result)
    end
  end
end
