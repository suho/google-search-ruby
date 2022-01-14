# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::PasswordsController, type: :controller do
  describe 'POST#create', devise_mapping: true do
    context 'given an invalid oauth application' do
      it 'returns forbidden status' do
        post :create, params: { user: { email: 'test@test.test' } }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'given a valid oauth application' do
      context 'given an email' do
        it 'returns success status' do
          Fabricate(:user, email: 'test@test.test')
          post :create, params: { user: { email: 'test@test.test' } }.merge(oauth_application_params)

          expect(response).to have_http_status(:success)
        end
      end

      context 'given an invalid email' do
        it 'returns unprocessable_entity status' do
          post :create, params: { user: { email: 'invalid_email@' } }.merge(oauth_application_params)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'given no email' do
        it 'returns unprocessable_entity status' do
          post :create, params: oauth_application_params

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
