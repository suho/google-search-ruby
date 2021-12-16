# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob
  queue_as :default

  def perform(keyword_id)
    keyword = Keyword.find(keyword_id)
    html = GoogleSearchService.new(keyword: keyword.keyword).call
    utf_8_html = html.force_encoding('iso8859-1').encode('utf-8')
    keyword.add_html(utf_8_html)
  rescue ActiveRecord::RecordNotFound, GoogleSearch::Errors::SearchKeywordError, ActiveRecord::StatementInvalid
    keyword.update_status(:failed)
  end
end
