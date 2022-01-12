# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchKeywordJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given a valid request' do
      it 'sets the keyword status as completed', vcr: 'services/google_search/search_keyword' do
        keyword = Fabricate(:keyword)
        described_class.perform_now keyword.id

        expect(keyword.reload.status).to eq('completed')
      end
    end
  end
end
