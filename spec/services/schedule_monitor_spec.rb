require 'rails_helper'

describe ScheduleMonitor do
  let(:radio){ FactoryBot.create :radio }
  let(:playlist) { FactoryBot.create :playlist, radio: radio }
  let(:show){ FactoryBot.create :scheduled_show }
  let(:liquidsoap_socket_class){ class_double("Liquidsoap::Socket") }
  let(:liquidsoap_socket){ instance_double("Liquidsoap::Socket") }
  it "issues a skip if a show is scheduled and is not currently playing" do
    scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")
    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      allow(liquidsoap_socket_class).to receive(:new).with("/tmp/datafruits/liquidsoap.sock").and_return(liquidsoap_socket)
      expect(liquidsoap_socket).to receive(:write).with("icecast.1.skip")
      ScheduleMonitor.perform radio, Time.now, liquidsoap_socket_class
    end
  end

  it "doesn't issue a skip if a show is scheduled and is already playing" do
    scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")
    radio.set_current_show_playing scheduled_show.id
    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      allow(liquidsoap_socket_class).to receive(:new).with("/tmp/datafruits/liquidsoap.sock").and_return(liquidsoap_socket)
      expect(liquidsoap_socket).not_to receive(:write).with("icecast.1.skip")
      ScheduleMonitor.perform radio, Time.now, liquidsoap_socket_class
    end
  end

  it "doesn't skip if the current show is not over yet and no_cue_out is set on the current show" do
    playlist.update no_cue_out: true
    scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")
    radio.set_current_show_playing scheduled_show.id
    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      allow(liquidsoap_socket_class).to receive(:new).with("/tmp/datafruits/liquidsoap.sock").and_return(liquidsoap_socket)
      expect(liquidsoap_socket).not_to receive(:write).with("icecast.1.skip")
      ScheduleMonitor.perform radio, Time.now, liquidsoap_socket_class
    end
  end
  xit "skips to the right track if the queue is full" # what was this supposed to mean
end
