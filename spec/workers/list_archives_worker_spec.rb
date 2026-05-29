require 'rails_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

describe ListArchivesWorker do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  before do
    # set up test cache
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear

    # immediately run sidekiq jobs
    Sidekiq::Testing.inline!
  end
  after do
    Sidekiq::Testing.disable!
  end

  it "puts chronological podcasts into cache" do
    radio = FactoryBot.create :radio, name: "garf_radio"
    current_time = Time.local(2025, 9, 1, 10, 5, 0)
    past_time = current_time - 2.months
    Timecop.freeze(past_time)
    show1 = FactoryBot.create :scheduled_show, radio: radio,
      title: "created first", start_at: 1.weeks.from_now, end_at: 1.hour.since(1.weeks.from_now), status: :archive_published
    show2 = FactoryBot.create :scheduled_show, radio: radio,
      title: "created second", start_at: 3.weeks.from_now, end_at: 1.hour.since(3.weeks.from_now), status: :archive_published
    show3 = FactoryBot.create :scheduled_show, radio: radio,
      title: "created third", start_at: 2.weeks.from_now, end_at: 1.hour.since(2.weeks.from_now), status: :archive_published
    expect(Rails.cache.exist?("chronological_archives/#{radio.id}")).to be_falsy
    Timecop.return
    Timecop.freeze(current_time)

    ListArchivesWorker.perform_now

    # Expect results in reverse chronological order
    expect(Rails.cache.exist?("chronological_archives/#{radio.id}")).to be_truthy
    expect(Rails.cache.read("chronological_archives/#{radio.id}")).to eq([show2, show3, show1])
  end
end
