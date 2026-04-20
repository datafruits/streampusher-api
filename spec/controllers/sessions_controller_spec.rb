require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:radio) { FactoryBot.create(:radio) }
  let(:password) { "password123" }
  let(:json_response) { JSON.parse(response.body) }

  let(:user) do
    user = FactoryBot.create(:user, password: password, password_confirmation: password)
    user.role = "dj"
    user.user_radios.build(radio: radio)
    user.save!
    user
  end

  describe "POST #create" do
    context "with valid credentials" do
      before do
        user
        post :create, params: { user: { login: user.username, password: password } }, format: :json
      end

      it "returns success" do
        expect(json_response["success"]).to eq(true)
      end

      it "returns the user login" do
        expect(json_response["login"]).to eq(user.username)
      end

      it "returns the user id" do
        expect(json_response["id"]).to eq(user.id)
      end
    end
  end
end
