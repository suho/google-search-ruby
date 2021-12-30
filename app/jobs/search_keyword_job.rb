# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :default

  def perform(keyword_id)
    @keyword = Keyword.find(keyword_id)
    begin
      html_response = GoogleSearchService.new(keyword: keyword.keyword).call
      save_keyword_results(html_response, GoogleParseService.new(html: html_response))
    rescue ActiveRecord::RecordNotFound, GoogleSearch::Errors::SearchKeywordError, ActiveRecord::StatementInvalid
      keyword.update_status(:failed)
    end
  end

  private

  attr_reader :keyword

  def save_keyword_results(html, parse_service)
    Keyword.transaction do
      # rubocop:disable Rails::SkipsModelValidations
      keyword.links.insert_all(parse_service.all_links)
      # rubocop:enable Rails::SkipsModelValidations
      keyword.update_result(html: html, parse_service: parse_service, status: :completed)
    end
  end
end
