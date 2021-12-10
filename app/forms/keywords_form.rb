# frozen_string_literal: true

class KeywordsForm
  include ActiveModel::Model

  attr_reader :keyword_ids

  def initialize(user)
    @user = user
  end

  def save(file)
    keywords = parse_keywords(file)
    return false unless keywords

    keyword_records = keywords.map { |keyword| keyword_record(keyword) }
    # rubocop:disable Rails::SkipsModelValidations
    @keyword_ids = Keyword.insert_all(keyword_records).map { |hash| hash['id'] }
    # rubocop:enable Rails::SkipsModelValidations
  rescue ActiveRecord::ActiveRecordError
    false
  end

  private

  attr_reader :user

  def parse_keywords(keywords_file)
    ParseKeywordsService.new(keywords_file).call
  end

  def keyword_record(keyword)
    return nil if keyword.blank?

    {
      user_id: user.id,
      keyword: keyword,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end
