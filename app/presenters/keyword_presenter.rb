# frozen_string_literal: true

class KeywordPresenter
  def initialize(keyword)
    @keyword = keyword
  end

  def keyword_id
    keyword.id
  end

  def keyword_text
    keyword.keyword
  end

  def keyword_result_html
    keyword.html
  end

  def formatted_created_at
    keyword.created_at.strftime('%F %H:%M:%S')
  end

  def keyword_completed?
    keyword.completed?
  end

  def ads_top_count
    keyword.ads_top_count
  end

  def ads_page_count
    keyword.ads_page_count
  end

  def non_ads_count
    keyword.non_ads_count
  end

  def total_links_count
    keyword.total_links_count
  end

  def status_html
    return '<div class="spinner-border spinner-border-sm" role="status"></div>' if keyword.in_progress?
    return '<div class="text-success">Completed</div>' if keyword.completed?
    return '<div class="text-danger">Failed</div>' if keyword.failed?
  end

  private

  attr_reader :keyword
end
