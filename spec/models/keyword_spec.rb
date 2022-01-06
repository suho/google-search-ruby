# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe '#update_status' do
    context 'when update the status with failed' do
      it 'returns failed for status' do
        keyword = Fabricate(:keyword)
        keyword.update_status(:failed)

        expect(keyword.status).to eq('failed')
      end
    end

    context 'when update the status with completed' do
      it 'returns failed for status' do
        keyword = Fabricate(:keyword)
        keyword.update_status(:completed)

        expect(keyword.status).to eq('completed')
      end
    end
  end

  describe '#update_result' do
    context 'when update keyword with sofa result (1 top ad, 7 total ads, 9 non ads and 170 total links)' do
      it 'update keyword with completed status', vcr: 'services/google_search/search_keyword_sofa' do
        keyword = Fabricate(:keyword)
        html_response = GoogleSearchService.new(keyword: keyword.keyword).call
        parse_service = GoogleParseService.new(html: html_response)
        keyword.update_result(html: html_response, parse_service: parse_service, status: :completed)

        expect(keyword.status).to eq('completed')
      end

      it 'update keyword with ads_top_count is 1', vcr: 'services/google_search/search_keyword_sofa' do
        keyword = Fabricate(:keyword)
        html_response = GoogleSearchService.new(keyword: keyword.keyword).call
        parse_service = GoogleParseService.new(html: html_response)
        keyword.update_result(html: html_response, parse_service: parse_service, status: :completed)

        expect(keyword.ads_top_count).to eq(1)
      end

      it 'update keyword with ads_page_count is 7', vcr: 'services/google_search/search_keyword_sofa' do
        keyword = Fabricate(:keyword)
        html_response = GoogleSearchService.new(keyword: keyword.keyword).call
        parse_service = GoogleParseService.new(html: html_response)
        keyword.update_result(html: html_response, parse_service: parse_service, status: :completed)

        expect(keyword.ads_page_count).to eq(7)
      end

      it 'update keyword with non_ads_count is 9', vcr: 'services/google_search/search_keyword_sofa' do
        keyword = Fabricate(:keyword)
        html_response = GoogleSearchService.new(keyword: keyword.keyword).call
        parse_service = GoogleParseService.new(html: html_response)
        keyword.update_result(html: html_response, parse_service: parse_service, status: :completed)

        expect(keyword.non_ads_count).to eq(9)
      end

      it 'update keyword with total_links_count is 170', vcr: 'services/google_search/search_keyword_sofa' do
        keyword = Fabricate(:keyword)
        html_response = GoogleSearchService.new(keyword: keyword.keyword).call
        parse_service = GoogleParseService.new(html: html_response)
        keyword.update_result(html: html_response, parse_service: parse_service, status: :completed)

        expect(keyword.total_links_count).to eq(170)
      end
    end
  end
end
