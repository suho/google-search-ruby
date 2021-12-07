# frozen_string_literal: true

class KeywordPresenter
  def initialize(keyword)
    @keyword = keyword
  end

  def keyword_text
    keyword.keyword
  end

  def formatted_created_at
    keyword.created_at.strftime('%F %H:%M:%S')
  end

  def status_html
    return '<div class="spinner-border spinner-border-sm" role="status"></div>' if keyword.in_progress?
    return '<div class="text-success">Completed</div>' if keyword.completed?
    return '<div class="text-danger">Failed</div>' if keyword.failed?
  end

  private

  attr_reader :keyword
end
