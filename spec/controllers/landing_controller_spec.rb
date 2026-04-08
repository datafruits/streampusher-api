require 'rails_helper'

RSpec.describe LandingController, :type => :controller do
  describe "GET #index" do
    before do
      allow(ScheduledShow).to receive(:current).and_return(double(first: nil))
    end

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "uses the hotwire layout" do
      get :index
      expect(response).to render_template(layout: "hotwire")
    end

    it "sets @april_fools based on the current date" do
      travel_to Date.new(2024, 4, 1) do
        get :index
        expect(assigns(:april_fools)).to eq(true)
      end
    end

    it "sets @april_fools to false on non-April Fools dates" do
      travel_to Date.new(2024, 3, 15) do
        get :index
        expect(assigns(:april_fools)).to eq(false)
      end
    end

    it "initializes @site_settings" do
      get :index
      expect(assigns(:site_settings)).to eq({})
    end
  end
end
