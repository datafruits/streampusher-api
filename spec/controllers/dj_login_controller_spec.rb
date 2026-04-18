require 'rails_helper'

RSpec.describe DjLoginController, type: :controller do
  let(:radio) { FactoryBot.create(:radio) }
  let(:dj) do
    user = FactoryBot.create(:user, username: 'testdj', email: 'testdj@example.com', password: 'secret123', password_confirmation: 'secret123', role: 'dj')
    radio.users << user
    user
  end
  let(:liq_secret) { 'test_liq_secret' }

  before do
    allow(Rails.application.secrets).to receive(:liq_secret).and_return(liq_secret)
    allow(controller).to receive(:current_radio).and_return(radio)
    allow(controller).to receive(:current_radio_required)
    allow(controller).to receive(:instance_variable_get).with(:@current_radio).and_return(radio)
    controller.instance_variable_set(:@current_radio, radio)
  end

  describe 'POST #create' do
    context 'without liq-secret header' do
      it 'returns unauthorized' do
        dj
        post :create, params: { user: dj.username, password: 'secret123' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid liq-secret header' do
      before do
        request.headers['liq-secret'] = liq_secret
      end

      it 'returns success for valid credentials' do
        dj
        post :create, params: { user: dj.username, password: 'secret123' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to be true
      end

      it 'returns unauthorized for invalid password' do
        dj
        post :create, params: { user: dj.username, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['success']).to be false
      end

      it 'returns unauthorized for unknown user' do
        post :create, params: { user: 'nobody', password: 'secret123' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['success']).to be false
      end

      it 'matches username case-insensitively' do
        dj
        post :create, params: { user: dj.username.upcase, password: 'secret123' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['success']).to be true
      end
    end

    context 'with invalid liq-secret header' do
      before do
        request.headers['liq-secret'] = 'wrong_secret'
      end

      it 'returns unauthorized' do
        dj
        post :create, params: { user: dj.username, password: 'secret123' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
