require 'rails_helper'

RSpec.describe Link, type: :model do
  xit "determines the font awesome character to use from the url" do
    expect(Link.new(url: "soundcloud.com/firedrill").glyph) .to eq "soundcloud"
  end
end
