require 'rails_helper'

RSpec.describe Shrimpo, type: :model do
  before do
    Time.zone = 'UTC'
    Timecop.freeze Time.local(2015)
    @start_at = Chronic.parse("today at 1:15 pm").utc
  end

  after do
    Timecop.return
  end

  it 'costs fruit tix based on duration' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 5000, level: 3
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo.save_and_deposit_fruit_tickets!

    shrimpo2 = Shrimpo.new start_at: @start_at, duration: "1 week", title: "Shrimp Champions 1 week", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo2.save_and_deposit_fruit_tickets!
  end

  xit 'no deposit returned if less than 3 entries'

  it 'sets end_at from duration' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", level: 3
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj, emoji: ":bgs:"
    shrimpo.save!
    expect(shrimpo.end_at).to eq shrimpo.start_at + 2.hours
    expect(shrimpo.duration).to eq "about 2 hours"
  end

  xit 'sets voting_end_at when changed to voting status' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj
    shrimpo.save!
  end

  it 'tallys the results' do
    gold_trophy = Trophy.create! name: "golden shrimpo"
    silver_trophy = Trophy.create! name: "silveren shrimpo"
    bronze_trophy = Trophy.create! name: "bronzeen shrimpo"
    consolation_trophy = Trophy.create! name: "good beverage"
    dj1 = User.create! role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create! role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create! role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create! role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:", gold_trophy: gold_trophy, silver_trophy: silver_trophy, bronze_trophy: bronze_trophy, consolation_trophy: consolation_trophy
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
    expect(ExperiencePointAward.count).to eq 16 # for voting and winning
    expect(FruitTicketTransaction.count).to eq 2

    # trophies ???
    expect(TrophyAward.where(user: entry2.user, shrimpo_entry: entry2, trophy: gold_trophy).count).to eq 1
    expect(TrophyAward.where(user: entry4.user, shrimpo_entry: entry4, trophy: silver_trophy).count).to eq 1
    expect(TrophyAward.where(user: entry3.user, shrimpo_entry: entry3, trophy: bronze_trophy).count).to eq 1
    good_bev_count = TrophyAward.where(user: entry1.user, shrimpo_entry: entry1, trophy: consolation_trophy).count
    puts "got #{good_bev_count} good beverages!"
    expect(TrophyAward.where(user: entry1.user, shrimpo_entry: entry1, trophy: consolation_trophy).count).to be >= 1
  end

  it 'tallys results for mega shrimpo' do
    gold_trophy = Trophy.create! name: "golden shrimpo"
    silver_trophy = Trophy.create! name: "silveren shrimpo"
    bronze_trophy = Trophy.create! name: "bronzeen shrimpo"

    categories = [
      "glop",
      "massive",
      "hacker",
      "anysong",
      "boing"
    ]

    consolation_trophy = Trophy.create! name: "good beverage"
    dj1 = User.create! role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 20000, level: 3
    dj2 = User.create! role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create! role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create! role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo_params = {  start_at: @start_at, duration: "3 months", title: "Shrimp Champions 2000 mega", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:", shrimpo_type: :mega, gold_trophy: gold_trophy, silver_trophy: silver_trophy, bronze_trophy: bronze_trophy, consolation_trophy: consolation_trophy }
    shrimpo = Shrimpo.new shrimpo_params
    categories.each do |category|
      shrimpo.shrimpo_voting_categories.build name: category, emoji: ":#{category}:"
    end
    shrimpo.save_and_deposit_fruit_tickets!

    expect(shrimpo.shrimpo_voting_categories.count).to eq 5

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4

    categories.each do |category|
      shrimpo_voting_category = shrimpo.shrimpo_voting_categories.find_by name: category
      entry1.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj2
      entry1.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj3
      entry1.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj4
    end

    categories.each do |category|
      shrimpo_voting_category = shrimpo.shrimpo_voting_categories.find_by name: category
      entry2.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj1
      entry2.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj3
      entry2.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj4
    end

    categories.each do |category|
      shrimpo_voting_category = shrimpo.shrimpo_voting_categories.find_by name: category
      entry3.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj1
      entry3.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj2
      entry3.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj4
    end

    categories.each do |category|
      shrimpo_voting_category = shrimpo.shrimpo_voting_categories.find_by name: category
      entry4.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj1
      entry4.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj2
      entry4.shrimpo_votes.create score: rand(1..6), shrimpo_voting_category: shrimpo_voting_category, user: dj3
    end

    shrimpo.voting!
    shrimpo.tally_results!

    # expect(entry1.total_score).to eq 5
    # expect(entry1.ranking).to eq 4
    # expect(entry2.total_score).to eq 17
    # expect(entry2.ranking).to eq 1
    # expect(entry3.total_score).to eq 8
    # expect(entry3.ranking).to eq 3
    # expect(entry4.total_score).to eq 12
    # expect(entry4.ranking).to eq 2
    puts ExperiencePointAward.pluck :amount
    expect(ExperiencePointAward.count).to eq 64 # for voting and winning
    expect(FruitTicketTransaction.count).to eq 2

    # trophies ???
    # expect(TrophyAward.where(user: entry2.user, shrimpo_entry: entry2, trophy: gold_trophy).count).to eq 1
    # expect(TrophyAward.where(user: entry4.user, shrimpo_entry: entry4, trophy: silver_trophy).count).to eq 1
    # expect(TrophyAward.where(user: entry3.user, shrimpo_entry: entry3, trophy: bronze_trophy).count).to eq 1
    # good_bev_count = TrophyAward.where(user: entry1.user, shrimpo_entry: entry1, trophy: consolation_trophy).count
    # puts "got #{good_bev_count} good beverages!"
    expect(TrophyAward.where(trophy: consolation_trophy).count).to be >= 1
    categories.each do |category|
      gold = Trophy.find_by name: "gold #{category}"
      silver = Trophy.find_by name: "silver #{category}"
      bronze = Trophy.find_by name: "bronze #{category}"
      expect(TrophyAward.where(trophy: gold).count).to be 1
      expect(TrophyAward.where(trophy: silver).count).to be 1
      expect(TrophyAward.where(trophy: bronze).count).to be 1
    end
  end

  it 'shows voting completion as percentage' do
    gold_trophy = Trophy.create! name: "golden shrimpo"
    silver_trophy = Trophy.create! name: "silveren shrimpo"
    bronze_trophy = Trophy.create! name: "bronzeen shrimpo"
    consolation_trophy = Trophy.create! name: "good beverage"
    dj1 = User.create! role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create! role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create! role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create! role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:", gold_trophy: gold_trophy, silver_trophy: silver_trophy, bronze_trophy: bronze_trophy, consolation_trophy: consolation_trophy
    shrimpo.save_and_deposit_fruit_tickets!

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4

    entry1.shrimpo_votes.create! score: 1, user: dj2
    entry4.shrimpo_votes.create! score: 2, user: dj2
    entry3.shrimpo_votes.create! score: 6, user: dj2

    expect(shrimpo.voting_completion(dj2)).to eq 100.0
  end

  it 'cant vote on own entry' do
    dj1 = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:"
    shrimpo.save_and_deposit_fruit_tickets!

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4

    vote = entry1.shrimpo_votes.new score: 1, user: dj1
    expect(vote.valid?).to eq false
  end

  it 'creates zip file' do
    gold_trophy = Trophy.create! name: "golden shrimpo"
    silver_trophy = Trophy.create! name: "silveren shrimpo"
    bronze_trophy = Trophy.create! name: "bronzeen shrimpo"
    consolation_trophy = Trophy.create! name: "good beverage"
    dj1 = User.create! role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC", fruit_ticket_balance: 1000, level: 3
    dj2 = User.create! role: 'dj', username: 'seacuke', email: "seacuke@gmail.com", password: "2boobies", time_zone: "UTC"
    dj3 = User.create! role: 'dj', username: 'djnameko', email: "djnameko@gmail.com", password: "2boobies", time_zone: "UTC"
    dj4 = User.create! role: 'dj', username: 'djgoodbye', email: "djgoodbye@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: @start_at, duration: "2 hours", title: "Shrimp Champions 2", rule_pack: "dont use pokemon samples", user: dj1, emoji: ":bgs:", gold_trophy: gold_trophy, silver_trophy: silver_trophy, bronze_trophy: bronze_trophy, consolation_trophy: consolation_trophy
    shrimpo.save_and_deposit_fruit_tickets!

    entry1 = shrimpo.shrimpo_entries.create! title: "zolo zoodo", user: dj1
    entry1.audio.attach(io: File.open("spec/fixtures/the_cowbell.mp3"), filename: "thecowbell.mp3")
    entry2 = shrimpo.shrimpo_entries.create! title: "mega banger 4000", user: dj2
    entry2.audio.attach(io: File.open("spec/fixtures/wau.mp3"), filename: "wau.mp3")
    entry3 = shrimpo.shrimpo_entries.create! title: "donkey kong club", user: dj3
    entry3.audio.attach(io: File.open("spec/fixtures/the_cowbell.mp3"), filename: "thecowbell.mp3")
    entry4 = shrimpo.shrimpo_entries.create! title: "fish pizza", user: dj4
    entry4.audio.attach(io: File.open("spec/fixtures/wau.mp3"), filename: "wau.mp3")

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

    shrimpo.create_entries_zip
  end
end
