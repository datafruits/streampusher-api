require 'rails_helper'

RSpec.describe DjSessionsController, type: :controller do
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
        expect(json_response["error"]).to eq("Invalid login or password")
      end
    end

    context "with valid credentials but no DJ role" do
      before do
        plain_user
        post :create, params: { user: { login: plain_user.username, password: password } }, format: :json
      end

      it "returns unauthorized status" do
        expect(response.status).to eq(401)
      end

      it "returns success false" do
        expect(json_response["success"]).to eq(false)
      end

      it "returns not a DJ error" do
        expect(json_response["error"]).to eq("User does not have DJ privileges")
      end
    end

    context "with valid manager credentials" do
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

      it "returns success for a manager" do
        expect(json_response["success"]).to eq(true)
      end
    end

    context "with valid admin credentials" do
      let(:admin_user) do
        user = FactoryBot.create(:user, username: "admin", email: "admin@test.com",
                                 password: password, password_confirmation: password)
        user.role = "admin"
        user.user_radios.build(radio: radio)
        user.save!
        user
      end

      before do
        admin_user
        post :create, params: { user: { login: admin_user.username, password: password } }, format: :json
      end

      it "returns success for an admin" do
        expect(json_response["success"]).to eq(true)
      end
    end
  end
end
