# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    pagy, keywords = pagy(current_user.keywords.order('created_at DESC'))
    keyword_presenters = keywords.map { |keyword| KeywordPresenter.new(keyword) }

    render locals: {
      pagy: pagy,
      keyword_presenters: keyword_presenters
    }
  end

  def create
    if save_keywords
      flash[:notice] = t('keywords.upload.success')
    else
      flash[:alert] = keywords_form.errors.full_messages.first
    end
    redirect_to keywords_path
  end

  private

  def save_keywords
    keywords_form.save(params[:keywords_file])
  end

  def keywords_form
    @keywords_form ||= KeywordsForm.new(current_user)
  end
end
