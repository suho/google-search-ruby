# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :request do
  describe 'GET #index' do
    it 'returns http success' do
      sign_in Fabricate(:user)
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'redirects to keywords index' do
      sign_in Fabricate(:user)
      post :create, params: keywords_file_params('keywords_valid.csv')

      expect(response).to redirect_to keywords_path
    end
  end
end
