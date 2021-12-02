# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def index; end

  def create
    parse_keywords
    redirect_to keywords_path
  end

  private

  def parse_keywords
    keywords_file = params[:keywords_file]
    ParseKeywordsService.new(keywords_file).call
  rescue GoogleSearch::Errors::KeywordsError => exception
    flash[:alert] = exception.message
  end
end
