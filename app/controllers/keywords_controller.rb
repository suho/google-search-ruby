# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords = pagy(current_user.keywords)
    keyword_presenters = keywords.map { |keyword| KeywordPresenter.new(keyword) }

    render locals: {
      pagy: pagy,
      keyword_presenters: keyword_presenters
    }
  end

  def create
    parse_keywords.each do |keyword|
      current_user.keywords.create(keyword: keyword)
    end
    redirect_to keywords_path
  end

  private

  def parse_keywords
    keywords_file = params[:keywords_file]
    ParseKeywordsService.new(keywords_file).call
  rescue GoogleSearch::Errors::KeywordsError => e
    flash[:alert] = e.message
    []
  end
end
