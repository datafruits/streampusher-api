require 'rails_helper'

describe StreamingExpAward do
  it 'creates exp point award with correct amount and type' do
    user = FactoryBot.create :user
    track = FactoryBot.create :track, uploaded_by: user
    StreamingExpAward.perform track
    expect(
      ExperiencePointAward.where(award_type: :streamingatron, amount: track.length / 30, user: track.uploaded_by).count).to eq 1
  end
end
