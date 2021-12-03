# frozen_string_literal: true

Fabricator(:keyword) do
  keyword FFaker::FreedomIpsum.word
  user Fabricate(:user)
end
