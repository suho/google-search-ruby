# frozen_string_literal: true

class UserAgents
  def self.array
    JSON.parse(File.read("#{Rails.root}/app/assets/files/user-agents_1000.json"))
  end
end
