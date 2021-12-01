# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  def index; end

  def create
    keywords = parse_keywords
    redirect_to keywords_path
  end

  private

  def parse_keywords
    begin
      keywords_file = params[:keywords_file]
      csv_data = CSV.read(keywords_file.path)
      csv_data.map do |row|
        row.first
      end
    rescue
      flash[:alert] = t("keywords.upload.invalid_file")
    end
  end
end
