# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  validates :keyword, presence: true, length: { maximum: 255 }

  enum status: { in_progress: 0, completed: 1, failed: 2 }

  def update_status(status)
    update(status: status)
  end

  def update_data(html:, parse_result:)
    update(
      html: html,
      status: :completed,
      ads_top_count: parse_result[:ads_top_count],
      ads_page_count: parse_result[:ads_page_count],
      non_ads_count: parse_result[:non_ads_count],
      total_links_count: parse_result[:total_links_count]
    )
  end
end
