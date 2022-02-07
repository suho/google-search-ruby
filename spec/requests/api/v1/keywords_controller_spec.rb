# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::KeywordsController, type: :request do
  describe 'GET#index' do
    context 'given a request without params' do
      it 'returns expected status' do
        api_sign_in
        get :index

        expect(response).to have_http_status(:success)
      end

      it 'returns response with valid keywords' do
        user = api_sign_in
        %w[Hello World Keyword].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
        get :index
        keywords = JSON.parse(response.body, symbolize_names: true)[:data].map { |object| object[:attributes][:keyword] }

        expect(keywords).to eq(%w[Keyword World Hello])
      end

      it 'returns expected meta data' do
        user = api_sign_in
        Fabricate.times(15, :keyword, user: user)
        get :index
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:meta]).to eq(page: 1, pages: 1, page_size: 20, records: 15)
      end
    end

    context 'given a request with pagination params' do
      context 'given a valid page number' do
        it 'returns expected status' do
          user = api_sign_in
          Fabricate.times(4, :keyword, user: user)
          get :index, params: { page: { number: 2, size: 2 } }

          expect(response).to have_http_status(:success)
        end

        it 'returns response with valid keywords' do
          user = api_sign_in
          %w[Hello World Keyword].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
          get :index, params: { page: { number: 2, size: 2 } }
          keywords = JSON.parse(response.body, symbolize_names: true)[:data].map { |object| object[:attributes][:keyword] }

          expect(keywords).to eq(%w[Hello])
        end

        it 'returns expected meta data' do
          user = api_sign_in
          Fabricate.times(20, :keyword, user: user)
          get :index, params: { page: { number: 2, size: 2 } }
          body = JSON.parse(response.body, symbolize_names: true)

          expect(body[:meta]).to eq(page: 2, pages: 10, page_size: 2, records: 20)
        end
      end

      context 'given an invalid page number' do
        it 'returns not_found status' do
          api_sign_in
          get :index, params: { page: { number: 1000, size: 2 } }

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'given a request with search keyword params' do
      it 'returns expected status' do
        user = api_sign_in
        %w[Hello World This Is Dummy Keyword List].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
        get :index, params: { keyword: 'He' }

        expect(response).to have_http_status(:success)
      end

      it 'returns response with valid keywords' do
        user = api_sign_in
        %w[Hello World This Is Hello].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
        get :index, params: { keyword: 'He' }
        keywords = JSON.parse(response.body, symbolize_names: true)[:data].map { |object| object[:attributes][:keyword] }

        expect(keywords).to eq(%w[Hello Hello])
      end

      it 'returns expected meta data' do
        user = api_sign_in
        %w[Hello World This Is Dummy Keyword List].each { |keyword| Fabricate(:keyword, user: user, keyword: keyword) }
        get :index, params: { keyword: 'He' }
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:meta]).to eq(page: 1, pages: 1, page_size: 20, records: 1)
      end
    end
  end

  describe 'POST#create' do
    context 'when upload a valid file' do
      it 'returns created status' do
        api_sign_in
        post :create, params: keywords_file_params('valid_keywords.csv')

        expect(response).to have_http_status(:created)
      end
    end

    context 'when upload no valid file' do
      it 'responds with alert message' do
        api_sign_in
        post :create

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error response with invalid message', api_authentication: :user do
        api_sign_in
        post :create
        expected_response = { errors: [{ detail: 'Invalid file!', code: 'invalid_file' }] }

        expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected_response)
      end
    end
  end

  describe 'GET#show' do
    context 'given a valid keyword id' do
      it 'returns success status' do
        user = api_sign_in
        keyword = Fabricate(:keyword, user: user, id: 1)
        get :show, params: { id: keyword.id }

        expect(response).to have_http_status(:success)
      end

      it 'returns the expected keyword' do
        user = api_sign_in
        keyword = Fabricate(:keyword, user: user, id: 1)
        get :show, params: { id: keyword.id }
        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:data][:id]).to eq('1')
      end
    end

    context 'given an invalid keyword id' do
      it 'returns not_found status' do
        api_sign_in
        get :show, params: { id: -1 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
