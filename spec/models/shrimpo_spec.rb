require 'rails_helper'

RSpec.describe Shrimpo, type: :model do
  it 'costs fruit tix based on duration' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 5000, level: 3
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo.save_and_deposit_fruit_tickets!

    shrimpo2 = Shrimpo.new start_at: Time.now, duration: "1 week", title: "Shrimp Champions 1 week", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo2.save_and_deposit_fruit_tickets!
  end

  xit 'no deposit returned if less than 3 entries'

  it 'sets end_at from duration' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", level: 3
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo.save!
    expect(shrimpo.end_at).to eq shrimpo.start_at + 2.hours
    expect(shrimpo.duration).to eq "about 2 hours"
  end

  # it 'sets voting_end_at when changed to voting status' do
  #   dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
  #   shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj
  #   shrimpo.save!
  # end
  #
  it 'tallys the results' do
    dj1 = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:"
    shrimpo.save_and_deposit_fruit_tickets!

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4

    entry1.shrimpo_votes.create score: 1, user: dj2
    entry1.shrimpo_votes.create score: 2, user: dj3
    entry1.shrimpo_votes.create score: 2, user: dj4

    entry2.shrimpo_votes.create score: 6, user: dj1
    entry2.shrimpo_votes.create score: 6, user: dj3
    entry2.shrimpo_votes.create score: 5, user: dj4

    entry3.shrimpo_votes.create score: 2, user: dj1
    entry3.shrimpo_votes.create score: 3, user: dj2
    entry3.shrimpo_votes.create score: 3, user: dj4

    entry4.shrimpo_votes.create score: 4, user: dj1
    entry4.shrimpo_votes.create score: 4, user: dj2
    entry4.shrimpo_votes.create score: 4, user: dj3

    shrimpo.voting!
    shrimpo.tally_results!

    expect(entry1.total_score).to eq 5
    expect(entry1.ranking).to eq 4
    expect(entry2.total_score).to eq 17
    expect(entry2.ranking).to eq 1
    expect(entry3.total_score).to eq 8
    expect(entry3.ranking).to eq 3
    expect(entry4.total_score).to eq 12
    expect(entry4.ranking).to eq 2
    puts ExperiencePointAward.pluck :amount
    expect(ExperiencePointAward.count).to eq 4
    expect(FruitTicketTransaction.count).to eq 2
  end

  it 'cant vote on own entry' do
    dj1 = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:"
    shrimpo.save_and_deposit_fruit_tickets!

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4

    vote = entry1.shrimpo_votes.new score: 1, user: dj1
    expect(vote.valid?).to eq false
  end
end