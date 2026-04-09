require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:radio) { FactoryBot.create :radio }
  let(:dj) { FactoryBot.create :user }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    context "when there is a currently scheduled show" do
      before do
        allow(controller).to receive(:current_radio).and_return(radio)
        controller.instance_variable_set(:@current_radio, radio)
        allow(radio).to receive(:current_scheduled_show).and_return(double("ScheduledShow"))
      end

      it "returns unauthorized" do
        post :create, params: { user: { login: dj.username, password: "password" } }
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns success false" do
        post :create, params: { user: { login: dj.username, password: "password" } }
        expect(JSON.parse(response.body)["success"]).to eq false
      end
    end

    context "when there is no currently scheduled show" do
      before do
        allow(controller).to receive(:current_radio).and_return(radio)
        controller.instance_variable_set(:@current_radio, radio)
        allow(radio).to receive(:current_scheduled_show).and_return(nil)
      end

      it "allows authentication to proceed" do
        post :create, params: { user: { login: dj.username, password: "password" } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when there is no current radio (regular web login)" do
      before do
        controller.instance_variable_set(:@current_radio, nil)
      end

      it "allows authentication to proceed regardless of scheduled shows" do
        post :create, params: { user: { login: dj.username, password: "password" } }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
