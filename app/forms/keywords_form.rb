# frozen_string_literal: true

class KeywordsForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates_with KeywordsFormValidator

  attr_reader :file, :keyword_ids

  def initialize(user)
    @user = user
  end

  def save(file)
    @file = file

    return false unless valid?
    
    keyword_records = parse_keywords.map { |keyword| keyword_record(keyword) }
    # rubocop:disable Rails::SkipsModelValidations
    @keyword_ids = Keyword.insert_all(keyword_records).map { |hash| hash['id'] }
    # rubocop:enable Rails::SkipsModelValidations
  rescue ActiveRecord::ActiveRecordError
    false
  end

  private

  attr_reader :user

  def parse_keywords
    csv_data = CSV.read(file.path)
    csv_data.map(&:first)
  end

  def keyword_record(keyword)
    return nil if keyword.blank?
    current_time = Time.current
    {
      user_id: user.id,
      keyword: keyword,
      created_at: current_time,
      updated_at: current_time
    }
  end
end
