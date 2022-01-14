# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::KeywordsController, type: :request do
  describe 'POST#create', api_authentication: :user do
    context 'when upload a valid file' do
      it 'returns created status' do
        sign_in Fabricate(:user)
        post :create, params: keywords_file_params('valid_keywords.csv')

        expect(response).to have_http_status(:created)
      end
    end

    context 'when upload no valid file' do
      it 'responds with alert message' do
        sign_in Fabricate(:user)
        post :create

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
