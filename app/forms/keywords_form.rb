# frozen_string_literal: true

class KeywordsForm
  include ActiveModel::Model

  validates_with KeywordsFormValidator

  attr_reader :file, :keyword_ids

  def initialize(user)
    @user = user
  end

  def save(file)
    @file = file

    return false if invalid?

    begin
      keyword_records = parse_keywords.map { |keyword| keyword_record(keyword) }
      # rubocop:disable Rails::SkipsModelValidations
      @keyword_ids = Keyword.insert_all(keyword_records).map { |keyword| keyword['id'] }
      # rubocop:enable Rails::SkipsModelValidations
    rescue ActiveRecord::ActiveRecordError
      errors.add(:base, I18n.t('keywords.upload.invalid_file'))
    end

    errors.empty?
  end

  private

  attr_reader :user

  def parse_keywords
    csv_data = CSV.read(file.path)
    csv_data.map(&:first)
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
