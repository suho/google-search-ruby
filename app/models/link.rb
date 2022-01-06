# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :keyword

  enum link_type: { ads_top: 0, non_ads: 1 }
end
