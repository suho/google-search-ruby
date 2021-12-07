# frozen_string_literal: true

class SearchKeywordJob < ApplicationJob

  queue_as :default

  def perform(keyword_id)
    keyword = Keyword.find(keyword_id)
    html = GoogleSearchService.new(keyword: keyword.keyword).call
    raise GoogleSearch::Errors::SearchKeywordError unless html
    utf_8_html = html.force_encoding('iso8859-1').encode('utf-8')
    update_keyword(keyword, utf_8_html)
  rescue ActiveRecord::RecordNotFound, GoogleSearch::Errors::SearchKeywordError, ActiveRecord::StatementInvalid
    update_keyword_status keyword, :failed
  end

  private

  def update_keyword_status(keyword, status)
    keyword.update! status: status
  end

  def update_keyword(keyword, html)
    Keyword.transaction do
      keyword.update! html: html
      keyword.update! status: :completed
    end
  end
end
