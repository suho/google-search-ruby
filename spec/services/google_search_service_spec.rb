# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleSearchService, type: :service do
  describe '#call' do
    context 'when searching a simple keyword' do
      it 'returns an response', vcr: 'services/google_search/search_keyword' do
        result = described_class.new(keyword: FFaker::Lorem.word).call

        expect(result).to be_an_instance_of(HTTParty::Response)
      end
    end
  end
end
