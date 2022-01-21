# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::KeywordsController, type: :request do
  describe 'POST#create', api_authentication: :user do
    context 'when upload a valid file' do
      it 'returns created status' do
        post :create, params: keywords_file_params('valid_keywords.csv')

        expect(response).to have_http_status(:created)
      end
    end

    context 'when upload no valid file' do
      it 'responds with alert message' do
        post :create

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error response with invalid message', api_authentication: :user do
        post :create
        expected_response = { errors: [{ detail: 'Invalid file!', code: 'invalid_file' }] }

        expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected_response)
      end
    end
  end
end
