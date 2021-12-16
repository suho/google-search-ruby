# frozen_string_literal: true

Fabricator(:keyword) do
  keyword FFaker::FreedomIpsum.word
  status :in_progress
  user { Fabricate(:user) }
end
