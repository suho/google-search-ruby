# frozen_string_literal: true

Fabricator(:doorkeeper_application, from: 'Doorkeeper::Application') do
  name { FFaker.name }
end
