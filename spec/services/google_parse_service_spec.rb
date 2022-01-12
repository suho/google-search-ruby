# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleParseService, type: :service do
  describe '#call' do
    context 'when parsing a result that having 1 top ad, 7 total ads, 9 non ads and 170 total links' do
      it 'counts 1 top ad link', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call

        expect(described_class.new(html: html_response).ads_top_count).to eq(1)
      end

      it 'counts 7 ads links on page', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call

        expect(described_class.new(html: html_response).ads_page_count).to eq(7)
      end

      it 'counts 9 non ads link', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call

        expect(described_class.new(html: html_response).non_ads_count).to eq(9)
      end

      it 'counts 170 total links on page', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call

        expect(described_class.new(html: html_response).total_links_count).to eq(170)
      end

      it 'gets 1 top ad link from all_links', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call
        all_links = described_class.new(html: html_response).all_links
        ads_top_links = all_links.select { |link| link[:link_type] == :ads_top }

        expect(ads_top_links.count).to eq(1)
      end

      it 'gets 9 non ads link from all_links', vcr: 'services/google_search/search_keyword_sofa' do
        html_response = GoogleSearchService.new(keyword: 'Sofa').call
        all_links = described_class.new(html: html_response).all_links
        non_ads_links = all_links.select { |link| link[:link_type] == :non_ads }

        expect(non_ads_links.count).to eq(9)
      end
    end
  end
end
