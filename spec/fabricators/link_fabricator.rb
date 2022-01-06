# frozen_string_literal: true

Fabricator(:link) do
  url FFaker::Internet.domain_name
  link_type :non_ads
  keyword { Fabricate(:keyword) }
end
