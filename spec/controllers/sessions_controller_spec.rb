require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:radio) { FactoryBot.create(:radio) }
  let(:password) { "password123" }
  let(:json_response) { JSON.parse(response.body) }

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
        expect(json_response["success"]).to eq(true)
      end

      it "returns dj_authorized true when user is a DJ on the radio" do
        expect(json_response["dj_authorized"]).to eq(true)
      end

      it "returns the user login" do
        expect(json_response["login"]).to eq(dj_user.username)
      end

      it "returns the user id" do
        expect(json_response["id"]).to eq(dj_user.id)
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
        expect(json_response["success"]).to eq(false)
      end

      it "returns an error message" do
        expect(json_response["error"]).to be_present
      end
    end

    context "with valid credentials but no DJ role" do
      before do
        plain_user
        post :create, params: { user: { login: plain_user.username, password: password } }, format: :json
      end

      it "returns success" do
        expect(json_response["success"]).to eq(true)
      end

      it "returns dj_authorized false" do
        expect(json_response["dj_authorized"]).to eq(false)
      end
    end

    context "with valid manager credentials associated with the radio" do
      let(:manager_user) do
        user = FactoryBot.create(:user, username: "mgr", email: "mgr@test.com",
                                 password: password, password_confirmation: password)
        user.role = "manager"
        user.user_radios.build(radio: radio)
        user.save!
        user
      end

      before do
        manager_user
        post :create, params: { user: { login: manager_user.username, password: password } }, format: :json
      end

      it "returns dj_authorized true for a manager" do
        expect(json_response["dj_authorized"]).to eq(true)
      end
    end

    context "with valid credentials for a DJ not associated with any radio" do
      let(:unassigned_dj) do
        user = FactoryBot.create(:user, username: "unassigned", email: "unassigned@test.com",
                                 password: password, password_confirmation: password)
        user.role = "dj"
        user.save!
        user
      end

      before do
        unassigned_dj
        post :create, params: { user: { login: unassigned_dj.username, password: password } }, format: :json
      end

      it "returns dj_authorized false when DJ is not associated with current radio" do
        expect(json_response["dj_authorized"]).to eq(false)
      end
    end
  end
end
