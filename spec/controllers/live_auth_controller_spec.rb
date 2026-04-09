require 'rails_helper'

RSpec.describe LiveAuthController, type: :controller do
  let(:radio) { FactoryBot.create :radio }
  let(:dj) { FactoryBot.create :user }
  let(:liq_secret) { Rails.application.secrets.liq_secret }

  before do
    allow(controller).to receive(:current_radio).and_return(radio)
    controller.instance_variable_set(:@current_radio, radio)
  end

  describe "POST #create" do
    context "when liq-secret header is missing" do
      it "returns unauthorized" do
        post :create, params: { user: dj.username, password: "password" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when liq-secret header is wrong" do
      it "returns unauthorized" do
        request.headers["liq-secret"] = "wrongsecret"
        post :create, params: { user: dj.username, password: "password" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when liq-secret is valid" do
      before { request.headers["liq-secret"] = liq_secret }

      context "when there is a currently scheduled show" do
        let(:playlist) { FactoryBot.create :playlist, radio: radio }
        let(:show_series) do
          show_series = ShowSeries.new(
            title: "test show", description: "desc",
            recurring_interval: "month", recurring_weekday: "Sunday",
            recurring_cadence: "First",
            start_time: Date.today.beginning_of_month,
            end_time: Date.today.beginning_of_month + 1.hour,
            start_date: Date.today.beginning_of_month,
            radio: radio
          )
          show_series.users << dj
          show_series.save!
          show_series
        end

        before do
          scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio, dj: dj,
            start_at: 30.minutes.ago, end_at: 30.minutes.from_now,
            show_series: show_series
          allow(radio).to receive(:current_scheduled_show).and_return(scheduled_show)
        end

        it "returns unauthorized" do
          post :create, params: { user: dj.username, password: "password" }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "when there is no currently scheduled show" do
        before { allow(radio).to receive(:current_scheduled_show).and_return(nil) }

        context "when user credentials are valid" do
          it "returns ok" do
            post :create, params: { user: dj.username, password: "password" }
            expect(response).to have_http_status(:ok)
          end
        end

        context "when user password is invalid" do
          it "returns unauthorized" do
            post :create, params: { user: dj.username, password: "wrongpassword" }
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context "when user does not exist" do
          it "returns unauthorized" do
            post :create, params: { user: "nonexistent", password: "password" }
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
