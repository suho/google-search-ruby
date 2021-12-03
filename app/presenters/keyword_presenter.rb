# frozen_string_literal: true

class KeywordPresenter
  def initialize(keyword)
    @keyword = keyword
  end

  def keyword_text
    keyword.keyword
  end

  def formatted_created_at
    keyword.created_at.strftime('%F')
  end

  def status_html
    return '<div class="spinner-border spinner-border-sm" role="status"></div>' if keyword.in_progress?
    return '<p class="text-success">Completed</p>' if keyword.completed?
    return '<p class="text-danger">Failed</p>' if keyword.failed?
  end

  private

  attr_reader :keyword
end
