require 'rails_helper'

RSpec.describe SocialIdentity, type: :model do
  let(:auth_hash){ { "provider" => "twitter",
                     "info" => { "nickname" => "freedrull" },
                     "uid" => 34235235,
                     "credentials" => { "token" => "238rdg9f98sohs",
                                       "token_secret" => "89gfd89sd98gsd98hfss"
                                      }
                    }
                  }
  let(:user) { FactoryBot.create :user }

  it "creates an identity from an omniauth hash" do
    identity = SocialIdentity.create_with_omniauth auth_hash, user.id
    expect(identity.uid).to eq auth_hash["uid"].to_s
  end

  it "finds an identity from an omniauth hash" do
    identity = SocialIdentity.create_with_omniauth auth_hash, user.id
    expect(SocialIdentity.find_with_omniauth(auth_hash)).to eq identity
  end
end
