# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def index
    @keywords = current_user.keywords
  end

  def create
    parse_keywords
    parse_keywords.each do |key|
      current_user.keywords.create(keyword: key)
    end
    redirect_to keywords_path
  end

  private

  def parse_keywords
    keywords_file = params[:keywords_file]
    ParseKeywordsService.new(keywords_file).call
  rescue GoogleSearch::Errors::KeywordsError => e
    flash[:alert] = e.message
  end
end
