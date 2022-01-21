# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::TokensController, type: :controller do
  describe 'POST#revoke' do
    context 'given a valid oauth application' do
      it 'returns success status' do
        application = Fabricate(:doorkeeper_application)
        access_token = Fabricate(:access_token, application_id: application.id)
        post :revoke, params: { token: access_token.token, client_id: application.uid, client_secret: application.secret }

        expect(response).to have_http_status(:success)
      end
    end

    context 'given an invalid oauth application' do
      it 'returns an error message' do
        access_token = Fabricate(:access_token, application_id: Fabricate(:doorkeeper_application).id)
        post :revoke, params: { token: access_token.token }
        expected_response = { errors: [{ code: 'unauthorized_client', detail: 'You are not authorized to revoke this token' }] }

        expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected_response)
      end
    end
  end
end
