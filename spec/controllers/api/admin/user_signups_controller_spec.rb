require 'rails_helper'

RSpec.describe Api::Admin::UserSignupsController, type: :controller do
  let(:admin_user) { User.create!(
    username: 'admin_test', 
    email: 'admin@test.com', 
    password: 'password123',
    role: 'admin',
    time_zone: 'UTC'
  )}

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    context 'when user is admin' do
      it 'returns user signups data' do
        # Create some test users in different months
        Timecop.freeze(Date.new(2023, 1, 15)) do
          User.create!(username: 'user1', email: 'user1@test.com', password: 'password123', time_zone: 'UTC')
          User.create!(username: 'user2', email: 'user2@test.com', password: 'password123', time_zone: 'UTC')
        end
        
        Timecop.freeze(Date.new(2023, 2, 10)) do
          User.create!(username: 'user3', email: 'user3@test.com', password: 'password123', time_zone: 'UTC')
        end

        get :index, format: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('user_signups')
        expect(json_response['user_signups']).to be_an(Array)
      end
    end

    context 'when user is not admin' do
      let(:regular_user) { User.create!(
        username: 'regular_test', 
        email: 'regular@test.com', 
        password: 'password123',
        role: 'listener',
        time_zone: 'UTC'
      )}

      before do
        sign_out admin_user
        sign_in regular_user
      end

      it 'returns forbidden' do
        get :index, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end