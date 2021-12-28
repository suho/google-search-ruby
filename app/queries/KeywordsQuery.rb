class KeywordsQuery

  attr_reader :keywords

  def initialize(keywords, filters)
    @keywords = keywords
    @filters = filters
  end

  def call
    @keywords = filtered_keywords if filter_by_keyword.present?
    @keywords = keywords.order('created_at DESC')
  end

  private

  attr_reader :filters

  def filter_by_keyword
    filters[:keyword]
  end

  def filtered_keywords
    query = "%#{filter_by_keyword}%"
    keywords.where('keyword ILIKE ?', query)
  end
end
