require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:radio) { FactoryBot.create(:radio) }
  let(:password) { "password123" }
  let(:dj_user) do
    user = FactoryBot.create(:user, password: password, password_confirmation: password)
    user.role = "dj"
    user.user_radios.build(radio: radio)
    user.save!
    user
  end
  let(:plain_user) do
    FactoryBot.create(:user, username: "plainuser", email: "plain@test.com",
                      password: password, password_confirmation: password)
  end

  describe "POST #create" do
    context "with valid DJ credentials" do
      before do
        dj_user
        post :create, params: { user: { login: dj_user.username, password: password } }, format: :json
      end

      it "returns success" do
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
      end

      it "returns dj_authorized true when user is a DJ on the radio" do
        json = JSON.parse(response.body)
        expect(json["dj_authorized"]).to eq(true)
      end

      it "returns the user login" do
        json = JSON.parse(response.body)
        expect(json["login"]).to eq(dj_user.username)
      end

      it "returns the user id" do
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(dj_user.id)
      end
    end

    context "with invalid credentials" do
      before do
        plain_user
        post :create, params: { user: { login: plain_user.username, password: "wrongpassword" } }, format: :json
      end

      it "returns unauthorized status" do
        expect(response.status).to eq(401)
      end

      it "returns success false" do
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(false)
      end

      it "returns an error message" do
        json = JSON.parse(response.body)
        expect(json["error"]).to be_present
      end
    end

    context "with valid credentials but no DJ role" do
      before do
        plain_user
        post :create, params: { user: { login: plain_user.username, password: password } }, format: :json
      end

      it "returns success" do
        json = JSON.parse(response.body)
        expect(json["success"]).to eq(true)
      end

      it "returns dj_authorized false" do
        json = JSON.parse(response.body)
        expect(json["dj_authorized"]).to eq(false)
      end
    end
  end
end
