# frozen_string_literal: true

class KeywordsForm
  include ActiveModel::Model

  attr_reader :keyword_ids

  def initialize(user)
    @user = user
  end

  def save(file)
    begin
      keywords = parse_keywords(file)
      keyword_records = keywords.map { |keyword| keyword_record(keyword) }
      @keyword_ids = Keyword.insert_all(keyword_records).map { |hash| hash['id'] }
    rescue ActiveRecord::ActiveRecordError
      errors.add(:base, I18n.t('keywords.save.error'))
    end
    errors.empty?
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
