# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def index; end

  def create
    keywords = load_keywords
    Rails.logger.debug(keywords)
    redirect_to keywords_path
  end

  private

  def load_keywords
    keywords_file = params[:keywords_file]
    csv_data = CSV.read(keywords_file.path)
    keywords = []
    csv_data.each do |row|
      keywords.append(row.first)
    end
    keywords
  end
end
