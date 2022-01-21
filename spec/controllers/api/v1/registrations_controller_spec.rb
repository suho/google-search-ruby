# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::RegistrationsController, type: :controller do
  describe 'POST#create', devise_mapping: true do
    context 'given a valid oauth application' do
      context 'given valid params' do
        it 'returns created status' do
          params = { user: { email: 'test@test.test', password: '12345678', password_confirmation: '12345678' } }
          post :create, params: params.merge(oauth_application_params)

          expect(response).to have_http_status(:created)
        end

        it 'returns an empty response body' do
          params = { user: { email: 'test@test.test', password: '12345678', password_confirmation: '12345678' } }
          post :create, params: params.merge(oauth_application_params)

          expect(response.body).to be_empty
        end
      end

      context 'given invalid params' do
        context 'given no user params' do
          it 'returns unprocessable entity status' do
            post :create, params: oauth_application_params

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'given no email params' do
          it 'returns unprocessable entity status' do
            params = { user: { password: '12345678', password_confirmation: '12345678' } }
            post :create, params: params.merge(oauth_application_params)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'given an existing email' do
          it 'returns unprocessable_entity status' do
            Fabricate(:user, email: 'test@test.test')
            params = { user: { email: 'test@test.test', password: '12345678', password_confirmation: '12345678' } }
            post :create, params: params.merge(oauth_application_params)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'given an invalid email' do
          it 'returns unprocessable_entity status' do
            params = { user: { email: 'invalid_email', password: '12345678', password_confirmation: '12345678' } }
            post :create, params: params.merge(oauth_application_params)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'given no password param' do
          it 'returns unprocessable_entity status' do
            params = { user: { email: 'test@test.test', password_confirmation: '12345678' } }
            post :create, params: params.merge(oauth_application_params)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'given a short password' do
          it 'returns unprocessable_entity status' do
            params = { user: { email: 'test@test.test', password: '12345', password_confirmation: '12345' } }
            post :create, params: params.merge(oauth_application_params)

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end

    context 'given an invalid oauth application' do
      it 'returns forbidden status' do
        params = { user: { email: 'test@test.test', password: 'test@test.test', password_confirmation: 'test@test.test' } }
        post :create, params: params

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
