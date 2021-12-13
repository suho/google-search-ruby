# frozen_string_literal: true

Fabricator(:keyword) do
  keyword FFaker::FreedomIpsum.word
  status 0
  user { Fabricate(:user) }
end
