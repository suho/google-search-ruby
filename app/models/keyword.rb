# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  validates :keyword, presence: true, length: { maximum: 255 }

  enum status: { in_progress: 0, completed: 1, failed: 2 }

  has_many :links, dependent: :destroy

  def update_status(status)
    update(status: status)
  end

  def update_result(html:, parse_service:, status:)
    update!(
      html: html,
      status: status,
      ads_top_count: parse_service.ads_top_count,
      ads_page_count: parse_service.ads_page_count,
      non_ads_count: parse_service.non_ads_count,
      total_links_count: parse_service.total_links_count
    )
  end
end
