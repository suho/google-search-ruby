# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords = pagy(current_user.keywords.order('created_at DESC').all)
    keyword_presenters = keywords.map { |keyword| KeywordPresenter.new(keyword) }

    render locals: {
      pagy: pagy,
      keyword_presenters: keyword_presenters
    }
  end

  def create
    if save_keywords
      SearchKeywordsJob.perform_later(keywords_form.keyword_ids)
      flash[:notice] = t('keywords.upload.success')
    else
      flash[:alert] = t('keywords.upload.invalid_file')
    end
    redirect_to keywords_path
  end

  private

  def keywords_form
    @keywords_form ||= KeywordsForm.new(current_user)
  end

  def save_keywords
    keywords_form.save(params[:keywords_file])
  end
end
