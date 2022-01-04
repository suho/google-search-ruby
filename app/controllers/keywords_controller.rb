# frozen_string_literal: true

require 'csv'

class KeywordsController < ApplicationController
  include Pagy::Backend

  def index
    keywords_query.call
    pagy, keywords = pagy(keywords_query.keywords)
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
      flash[:alert] = keywords_form.errors.full_messages.first
    end
    redirect_to keywords_path
  end

  def show
    keyword = Keyword.includes(:links).find(params[:id])
    presenter = KeywordPresenter.new(keyword)

    render locals: {
      presenter: presenter
    }
  end

  private

  def save_keywords
    keywords_form.save(params[:keywords_file])
  end

  def keywords_form
    @keywords_form ||= KeywordsForm.new(current_user)
  end

  def keywords_query
    @keywords_query ||= KeywordsQuery.new(current_user.keywords, permitted_params)
  end

  def permitted_params
    params.permit(:keyword)
  end
end
