require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ShowSeries, :type => :model do
  describe "saving recurrences" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    xit "saves recurring shows if recurring is true"
    xit "creates a unique slug for each recurrence"
    xit "updates all recurring shows attributes"
    xit "doesnt duplicate slugs on update"
  end
end
