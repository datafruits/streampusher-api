require 'rails_helper'

describe ScheduleMonitor do
  before :each do
    Redis.current = MockRedis.new
  end
  let(:radio){ FactoryBot.create :radio }
  let(:playlist) { FactoryBot.create :playlist, radio: radio }
  let(:show){ FactoryBot.create :scheduled_show }
  let(:dj){ FactoryBot.create :user }
  let(:liquidsoap_requests_class) { class_double("LiquidsoapRequests").as_stubbed_const }
  let(:liquidsoap) { instance_double("LiquidsoapRequests") }

  it "sets current show playing in redis to nil if there is no scheduled show in the db" do
    ScheduleMonitor.perform radio, Time.now
    expect(radio.current_show_playing.blank?).to eq true
  end
  describe "when the next show is due to start playing" do
    it "issues a skip when there is no previous show" do
      scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
        start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am"),
        dj: dj
      Timecop.travel Chronic.parse("January 1st 2090 at 10:31 pm") do
        allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
        expect(liquidsoap).to receive(:skip)
        expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
        ScheduleMonitor.perform radio, Time.now
        expect(radio.current_show_playing.to_i).to eq scheduled_show.id.to_i
      end
    end
    describe "and when the current show is not finished playing" do
      it "adds the playlist from the next show to the queue if the previous show has no_cue_out set to true and doesn't skip" do
        playlist.update no_cue_out: true
        scheduled_show1 = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
          start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:00 pm"),
          dj: dj
        scheduled_show2 = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
          start_at: Chronic.parse("January 1st 2090 at 11:00 pm"), end_at: Chronic.parse("January 1st 2090 at 11:30 pm"),
          dj: dj
        Timecop.travel Chronic.parse("January 1st 2090 at 10:31 pm") do
          allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
          expect(liquidsoap).to receive(:skip)
          #expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
          ScheduleMonitor.perform radio, Time.now
          expect(radio.current_show_playing.to_i).to eq scheduled_show1.id.to_i
        end
        Timecop.travel Chronic.parse("January 1st 2090 at 11:01 pm") do
          allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
          expect(liquidsoap).not_to receive(:skip)
          #expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
          ScheduleMonitor.perform radio, Time.now
          expect(radio.current_show_playing.to_i).to eq scheduled_show2.id.to_i
        end
      end
      it "skips to the playlist from the next show if the previous show has no_cue_out set to false" do
        playlist.update no_cue_out: false
        scheduled_show1 = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
          start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:00 pm"),
          dj: dj
        scheduled_show2 = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
          start_at: Chronic.parse("January 1st 2090 at 11:00 pm"), end_at: Chronic.parse("January 1st 2090 at 11:30 pm"),
          dj: dj
        Timecop.travel Chronic.parse("January 1st 2090 at 10:31 pm") do
          allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
          expect(liquidsoap).to receive(:skip)
          #expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
          ScheduleMonitor.perform radio, Time.now
          expect(radio.current_show_playing.to_i).to eq scheduled_show1.id.to_i
        end
        Timecop.travel Chronic.parse("January 1st 2090 at 11:01 pm") do
          allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
          expect(liquidsoap).to receive(:skip)
          #expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
          ScheduleMonitor.perform radio, Time.now
          expect(radio.current_show_playing.to_i).to eq scheduled_show2.id.to_i
        end
      end
    end
  end
  describe "when the current show is already playing at its proper time" do
    # how do i test that it does nothing???
    it "does nothing" do
      scheduled_show1 = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
        start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:00 pm"),
        dj: dj
      Timecop.travel Chronic.parse("January 1st 2090 at 10:31 pm") do
        allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
        expect(liquidsoap).to receive(:skip)
        expect_any_instance_of(ScheduledShow).to receive(:queue_playlist!)
        ScheduleMonitor.perform radio, Time.now
      end
      Timecop.travel Chronic.parse("January 1st 2090 at 10:45 pm") do
        allow(liquidsoap_requests_class).to receive(:new).with(radio.id).and_return(liquidsoap)
        expect(liquidsoap).not_to receive(:skip)
        expect_any_instance_of(ScheduledShow).not_to receive(:queue_playlist!)
        ScheduleMonitor.perform radio, Time.now
      end
    end
  end
  describe "if current show is_live" do
    it "does nothing"
  end
  describe "if current show's playlist is the default one" do
    it "does nothing"
  end
end
