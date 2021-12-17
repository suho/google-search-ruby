# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  validates :keyword, presence: true, length: { maximum: 255 }

  enum status: { in_progress: 0, completed: 1, failed: 2 }

  def update_status(status)
    update(status: status)
  end

  def add_html(html)
    update(html: html, status: :completed)
  end
end
