# frozen_string_literal: true

class GoogleSearchService

  BASE_URL = 'https://www.google.com/search'

  def initialize(keyword:)
    @uri = URI("#{BASE_URL}?q=#{keyword}")
    @user_agent = UserAgents.array.sample
  end

  def call
    data = HTTParty.get(@uri, { headers: { 'User-Agent' => user_agent } })
    return false unless data.response.code == '200'
    data
  rescue GoogleSearch::Errors::SearchKeywordError => e
    Rails.logger.error "Error with '#{keyword}' thrown an error: #{e}".colorize(:red)
    false
  end

  private

  attr_reader :keywords, :uri, :user_agent
end
