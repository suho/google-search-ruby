# frozen_string_literal: true

class KeywordSerializer
  include JSONAPI::Serializer

  attributes :keyword,
             :status,
             :ads_top_count,
             :ads_page_count,
             :non_ads_count,
             :total_links_count,
             :created_at

  attribute :html, if: proc { |_, params| params[:show_detail] }

  has_many :links
end
