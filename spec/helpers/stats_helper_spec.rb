require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StatsHelper. For example:
#
# describe SelectionEventsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe StatsHelper, type: :helper do
  describe "average_sessions_per_hour" do
    before do
      @radio = FactoryGirl.create :radio
      3.times {
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:02 pm"), end_at: Chronic.parse("yesterday at 8:08 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:12 pm"), end_at: Chronic.parse("yesterday at 8:15 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:48 pm"), end_at: Chronic.parse("yesterday at 8:49 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:12 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:22 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
      }
    end
    it "shows the average sessions per hour for the given period" do
      listens = @radio.listens
      expect(helper.average_sessions_per_hour(listens.group_by_hour(:start_at).count)).to eq 7
    end
  end

  describe "average_listening_minutes_per_session" do
    before do
      @radio = FactoryGirl.create :radio
      3.times {
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:02 pm"), end_at: Chronic.parse("yesterday at 8:08 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:12 pm"), end_at: Chronic.parse("yesterday at 8:15 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:48 pm"), end_at: Chronic.parse("yesterday at 8:49 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:12 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:22 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
      }
    end
    it "shows the average listening minutes per hour for the given period" do
      listens = @radio.listens
      expect(helper.average_listening_minutes_per_session(listens)).to eq 18.8
    end
  end

  describe "average_listening_minutes_per_hour" do
    before do
      @radio = FactoryGirl.create :radio
      3.times {
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:02 pm"), end_at: Chronic.parse("yesterday at 8:08 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:12 pm"), end_at: Chronic.parse("yesterday at 8:15 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 8:48 pm"), end_at: Chronic.parse("yesterday at 8:49 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:12 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
        @radio.listens.create start_at: Chronic.parse("yesterday at 9:22 pm"), end_at: Chronic.parse("yesterday at 9:59 pm"),
          icecast_listener_id: 1
      }
    end
    it "shows the average listened minutes per session for the given period" do
      listens = @radio.listens
      expect(helper.average_listening_minutes_per_hour(listens)).to eq({Chronic.parse("yesterday at 8:00 pm").utc => 3, Chronic.parse("yesterday at 9:00 pm").utc => 42})
    end
  end
end
