require "rails_helper"

RSpec.describe AccountMailer, type: :mailer do
  let(:user){ FactoryGirl.create :user, subscription: FactoryGirl.create(:subscription) }
  let(:invoice){ { amount: "1900", currency: "USD", amount_due: "950" } }
  it "sends invoice mail" do
    mail = AccountMailer.invoice(user, invoice).deliver_now
    puts mail.body
  end
  describe "with coupon" do
    let(:invoice){ { amount: "1900", currency: "USD", amount_due: "950", coupon: { percent_off: 50 } } }
    it "shows coupon information if coupon was used" do
      mail = AccountMailer.invoice(user, invoice).deliver_now
      expect(mail.body.include?("Coupon"))
      expect(mail.body.include?("50% off"))
    end
  end
end
