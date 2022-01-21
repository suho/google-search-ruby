# frozen_string_literal: true

Fabricator(:access_token, from: 'Doorkeeper::AccessToken') do
  token FFaker::FreedomIpsum.word
end
