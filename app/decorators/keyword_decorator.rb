# frozen_string_literal: true

class KeywordDecorator
  def initialize(keyword)
    @keyword = keyword
  end

  def keyword
    @keyword.keyword
  end

  def created_at
    @keyword.created_at.strftime('%F')
  end

  def status_html
    return '<div class="spinner-border spinner-border-sm" role="status"></div>' if @keyword.in_progress?
    return '<p class="text-success">Completed</p>' if @keyword.completed?
    return '<p class="text-danger">Failed</p>' if @keyword.failed?
  end
end
