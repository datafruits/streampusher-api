require 'rails_helper'

RSpec.describe Label, type: :model do
  it 'always save the name as downcase' do
    radio = FactoryBot.create :radio
    label = Label.create name: 'FooOO', radio: radio
    expect(label.name).to eq 'foooo'
  end
end
