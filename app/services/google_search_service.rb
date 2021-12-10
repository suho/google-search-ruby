# frozen_string_literal: true

class GoogleSearchService
  BASE_URL = 'https://www.google.com/search'

  def initialize(keyword:)
    @uri = URI("#{BASE_URL}?q=#{CGI.escape(keyword)}")
    @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/605.1.15 (KHTML, like Gecko) '\
                  'Version/11.1.2 Safari/605.1.15'
  end

  def call
    data = HTTParty.get(@uri, { headers: { 'User-Agent' => user_agent } })
    return false unless data.response.code == '200'

    data
  rescue GoogleSearch::Errors::SearchKeywordError => e
    Rails.logger.error "Fetch data with '#{keyword}' thrown an error: #{e}"
    false
  end

  private

  attr_reader :uri, :user_agent
end
