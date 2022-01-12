# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  context 'given empty keywords list' do
    context 'given no filter' do
      it 'returns an empty keywords list' do
        user = Fabricate(:user)
        keyword_query = described_class.new(user.keywords, {})
        keyword_query.call

        expect(keyword_query.keywords).to be_empty
      end
    end

    context 'given a keyword filter' do
      it 'returns an empty keywords list' do
        user = Fabricate(:user)
        keyword_query = described_class.new(user.keywords, { keyword: 'awesome' })
        keyword_query.call

        expect(keyword_query.keywords).to be_empty
      end
    end
  end

  context 'given a user with 2 keywords' do
    context 'given no filter' do
      it 'returns list of keywords that is ordered by created at descending' do
        user = Fabricate(:user)
        (1.day.ago.to_date..Time.zone.today).each_with_index { |date, index| Fabricate(:keyword, id: index, user: user, created_at: date) }
        keyword_query = described_class.new(user.keywords, {})
        keyword_query.call

        expect(keyword_query.keywords.map(&:id)).to eq([1, 0])
      end
    end

    context 'given a keyword filter' do
      it 'returns list of keywords that is ordered by created at descending and filter by the keyword filter' do
        user = Fabricate(:user)
        %w[Hello World].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
        keyword_query = described_class.new(user.keywords, { keyword: 'Hello' })
        keyword_query.call

        expect(keyword_query.keywords.map(&:keyword)).to eq(%w[Hello])
      end
    end
  end
end
