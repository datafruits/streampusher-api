require "rails_helper"

RSpec.describe AccountMailer, type: :mailer do
  let(:user){ FactoryGirl.create :user, subscription: FactoryGirl.create(:subscription) }
  let(:invoice){ { amount: "1900", currency: "USD" } }
  it "sends invoice mail" do
    mail = AccountMailer.invoice(user, invoice).deliver_now
    puts mail.body
  end
end
