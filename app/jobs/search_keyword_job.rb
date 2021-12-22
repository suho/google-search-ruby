# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :default

  def perform(keyword_id)
    keyword = Keyword.find(keyword_id)
    begin
      html = GoogleSearchService.new(keyword: keyword.keyword).call

      parse_service = GoogleParseService.new(html: html)
      result = parse_service.result
      keyword.update_data(html: html, parse_result: result)
    rescue ActiveRecord::RecordNotFound, GoogleSearch::Errors::SearchKeywordError, ActiveRecord::StatementInvalid
      keyword.update_status(:failed)
    end
  end
end
