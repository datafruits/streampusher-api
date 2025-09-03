require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ScheduledShow, :type => :model do
  before do
    Sidekiq::Testing.inline!

    @radio = Radio.create name: 'datafruits'
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @playlist = Playlist.create radio: @radio, name: "big tunes"
    @start_at = Chronic.parse("today at 1:15 pm").utc
    @end_at = Chronic.parse("today at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")
  end
  after do
    Sidekiq::Testing.disable!
  end

  describe "performers" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    it "sets the DJ as the performer if no performers are specified" do
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey", dj: @dj
      expect(@scheduled_show.performers).to include(@dj)
      expect(@scheduled_show.performers.count).to eq 1
    end

    it "doesnt save extra performers" do
      @scheduled_show = ScheduledShow.create radio: @radio,
        playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey",
        dj: @dj,
        scheduled_show_performers_attributes: { "0": { user_id: @dj.id } }
      expect(@scheduled_show.performers).to include(@dj)
      expect(@scheduled_show.performers.count).to eq 1
    end

    it "requires a guest if is_guest?" do
      @scheduled_show = ScheduledShow.new radio: @radio,
        playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey",
        dj: @dj, is_guest: true,
        scheduled_show_performers_attributes: { "0": { user_id: @dj.id } }
      expect(@scheduled_show.valid?).to eq false
      expect(@scheduled_show.errors[:guest]).to be_present

      @scheduled_show.guest = "special guest"
      expect(@scheduled_show.valid?).to eq true
    end
  end

  describe "slugs" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    it "saves the unique slug with title and id" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("today at 5:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey hey", dj: @dj
      expect(@scheduled_show.slug).to eq "hey-hey-01012015"
    end
  end

  describe "override time zone" do
    it "set time_zone to save in" do
      Time.use_zone "Tokyo" do
        Timecop.travel Time.zone.parse("2090-01-01 08:00") do
          start_at = Time.zone.parse("2090-02-01 09:00")
          end_at = Time.zone.parse("2090-02-01 11:00")

          time_zone = "Eastern Time (US & Canada)"
          @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, time_zone: time_zone, title: "my show with dj steve martin", dj: @dj

          format = "%a, %d %b %Y %H:%M:%S"
          expect(@scheduled_show.start_at).to eq start_at.strftime(format).in_time_zone(time_zone)
          expect(@scheduled_show.end_at).to eq end_at.strftime(format).in_time_zone(time_zone)
        end
      end
    end
  end

  describe "validations" do
    it "start time cannot be in the past" do
      start_at = Chronic.parse("yesterday at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey", dj: @dj
      expect(@scheduled_show.errors[:start_at]).to be_present
    end
    it "end time cannot be in the past" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("2 days ago at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey"
      expect(@scheduled_show.errors[:end_at]).to be_present
    end
    it "end time cannot be before start time" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey", dj: @dj
      expect(@scheduled_show.errors[:end_at]).to be_present
    end
  end

  # describe "recurring shows" do
  #   before do
  #     Time.zone = 'UTC'
  #     Timecop.freeze Time.local(2015)
  #   end
  #
  #   after do
  #     Timecop.return
  #   end
  #
  #   it "saves recurring shows if recurring is true" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     expect(ScheduledShow.where("start_at >= (?) AND start_at <= (?)", start_at.beginning_of_month, start_at.end_of_month).count).to eq 1
  #     expect(recurring_show.recurrences.count).to eq 275
  #     # it copies the performers over
  #     expect(recurring_show.recurrences.map {|m| m.performers.count }.uniq).to eq [1]
  #
  #     start_at = Chronic.parse("today at 3:15 pm").utc
  #     end_at = Chronic.parse("today at 5:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey weekly edition", dj: @dj
  #     expect(ScheduledShow.where(start_at: start_at).count).to eq 1
  #
  #     start_at = Chronic.parse("today at 3:15 pm").utc
  #     end_at = Chronic.parse("today at 5:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "biweek", title: "hey weekly edition", dj: @dj
  #     expect(recurring_show.recurrences.count).to eq 600
  #     expect(recurring_show.recurrences.map {|m| m.performers.count }.uniq).to eq [1]
  #   end
  #
  #   it "creates a unique slug for each recurrence" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     expect(ScheduledShow.where("start_at >= (?) AND start_at <= (?)", start_at.beginning_of_month, start_at.end_of_month).count).to eq 1
  #     count = recurring_show.recurrences.count
  #     expect(count).to eq 275
  #     expect(recurring_show.recurrences.pluck(:slug).uniq.count).to eq count
  #   end
  #
  #   it "doesnt duplicate slugs on update" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     new_start_at = Chronic.parse("today at 11:00 am").utc
  #     recurring_show.update start_at: new_start_at, update_all_recurrences: true
  #
  #     count = recurring_show.recurrences.count
  #     expect(count).to eq 275
  #     expect(recurring_show.recurrences.pluck(:slug).uniq.count).to eq count
  #   end
  #
  #   # FIXME end_at cannot be before start_at
  #   #
  #   # updating recurrances needs to take into account that end_at should update as well
  #   xit "updates all recurring shows attributes" do
  #     Timecop.return do
  #       VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, match_requests_on: [:method, :host, :s3_image_matcher]) do
  #         start_at = 4.hours.from_now.utc
  #         end_at = 6.hours.from_now.utc
  #         recurring_show = ScheduledShow.create! radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #         new_start_at = 2.hours.from_now.utc
  #         new_title = "new title 2"
  #         recurring_show.update! start_at: new_start_at, title: new_title, update_all_recurrences: true
  #         recurring_show.recurrences.each do |recurrence|
  #           expect(recurrence.start_at.hour).to eq new_start_at.hour
  #           expect(recurrence.start_at.min).to eq new_start_at.min
  #           expect(recurrence.start_at.sec).to eq new_start_at.sec
  #           expect(recurrence.title).to eq new_title
  #         end
  #       end
  #     end
  #   end
  #
  #   it "updates this recurrance only" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey", dj: @dj
  #     new_start_at = Chronic.parse("today at 11:00 am").utc
  #     recurring_show.update start_at: new_start_at, update_all_recurrences: false
  #     recurring_show.recurrences.each do |recurrence|
  #       expect(recurrence.start_at.hour).to eq start_at.hour
  #       expect(recurrence.start_at.min).to eq start_at.min
  #       expect(recurrence.start_at.sec).to eq start_at.sec
  #     end
  #   end
  #
  #   it "updates all recurring shows with a new recurrence" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey", dj: @dj
  #     expect(recurring_show.recurrences.count).to eq 1200
  #     recurring_show.update recurring_interval: "month"
  #     recurring_show.reload
  #     expect(recurring_show.recurrences.count).to eq 275
  #   end
  #
  #   it "deletes all recurring shows if destroy_recurrences is set" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     recurring_show.destroy_recurrences = true
  #     recurring_show.destroy
  #     expect(recurring_show.recurrences.count).to eq 0
  #   end
  #
  #   it "doesn't delete all recurring shows if destroy_recurrences is not set" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     recurring_show.destroy
  #     expect(recurring_show.recurrences.count).to eq 275
  #   end
  #
  #   it "only deletes recurring shows in the future" do
  #     start_at = Chronic.parse("today at 1:15 pm").utc
  #     end_at = Chronic.parse("today at 3:15 pm").utc
  #     recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
  #     Timecop.travel 6.months.from_now do
  #       recurring_show.destroy_recurrences = true
  #       recurring_show.destroy
  #       expect(recurring_show.recurrences.count).to eq 5
  #     end
  #   end
  # end

  describe "dst handling" do
    xit "updates all recurrences +1 hour for DST" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey", dj: @dj
      recurring_show.recurrences.each do |r|
        expect(r.start_at).to eq start_at
        expect(r.end_at).to eq end_at
      end
      recurring_show.fall_forward_recurrances_for_dst!
      recurring_show.recurrences.each do |r|
        expect(r.start_at).to eq start_at+1.hour
        expect(r.end_at).to eq end_at+1.hour
      end
    end
  end

  describe "queue_playlist!" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    let(:liquidsoap_requests_class) { class_double("LiquidsoapRequests").as_stubbed_const }
    let(:liquidsoap) { instance_double("LiquidsoapRequests") }
    xit "it clears the redis current_show_playing if destroyed and playing"
    it "queues the show's entire playlist in liquidsoap" do
      allow(liquidsoap_requests_class).to receive(:new).with(@radio.id).and_return(liquidsoap)
      Sidekiq::Testing.fake!
      start_at = Chronic.parse("today at 2:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      5.times do |i|
        @playlist.tracks << FactoryBot.create(:track, radio: @radio)
      end
      @scheduled_show = ScheduledShow.create! radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey", dj: @dj
      PersistPlaylistToRedis.perform @playlist
      @playlist.tracks.each do |track|
        expect(liquidsoap).to receive(:add_to_queue).with(track.url)
      end
      @scheduled_show.queue_playlist!
    end

    it "calls PersistPlaylistToRedis if empty in redis" do
      allow(liquidsoap_requests_class).to receive(:new).with(@radio.id).and_return(liquidsoap)
      Sidekiq::Testing.fake!
      start_at = Chronic.parse("today at 2:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      5.times do |i|
        @playlist.tracks << FactoryBot.create(:track, radio: @radio)
      end
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey", dj: @dj
      @playlist.tracks.each do |track|
        expect(liquidsoap).to receive(:add_to_queue).with(track.url)
      end
      @scheduled_show.queue_playlist!
    end
  end

  describe "archive recordings" do
    before do
      Sidekiq::Testing.inline!
    end
    after do
      Sidekiq::Testing.disable!
    end

    it "starts processing the recording after assigning a recording, then assigns the track to the show" do
      show_series = ShowSeries.new title: "monthly jammer jam", description: "wow", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, match_requests_on: [:method, :host, :uri], preserve_exact_body_bytes: true) do
        recording1 = FactoryBot.create :recording, path: "spec/fixtures/the_cowbell.mp3", radio: @radio
        start_at = 4.hours.from_now.utc
        end_at = 6.hours.from_now.utc
        @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey hey", dj: @dj, recording: recording1, show_series: show_series
        @scheduled_show.save!
        expect(@scheduled_show.tracks.count).to eq 1
        @scheduled_show.update status: :archive_published
      end

      expect(@scheduled_show.radio.default_playlist.tracks.include?(@scheduled_show.tracks.first)).to eq true
    end
  end

  describe "prerecord_file" do
    before do
      Sidekiq::Testing.fake!
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    it "makes a playlist and sets it when assigning the prerecord_file attr" do
      track = FactoryBot.create :track, radio: @radio, audio_file_name: "http://s3.amazonaws.com/streampusher/doo.mp3"
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey", dj: @dj
      @scheduled_show.prerecord_track_id = track.id
      @scheduled_show.save!
      expect(@scheduled_show.playlist.tracks.first.id).to eq(track.id)
      expect(@scheduled_show.prerecord_track_id).to eq(track.id)
    end

    it "syncs track title after update" do
      track = FactoryBot.create :track, radio: @radio, audio_file_name: "http://s3.amazonaws.com/streampusher/doo.mp3"
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey", dj: @dj
      @scheduled_show.save!
      track.update scheduled_show: @scheduled_show
      @scheduled_show.save!
      track.reload
      expect(track.title).to eq @scheduled_show.formatted_episode_title
    end

    it "assigns prerecord file to archive" do
      track = FactoryBot.create :track, radio: @radio, audio_file_name: "http://s3.amazonaws.com/streampusher/doo.mp3"
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey", dj: @dj
      @scheduled_show.prerecord_track_id = track.id
      @scheduled_show.save!
      expect(@scheduled_show.tracks.count).to eq 0
      expect(@scheduled_show.playlist.tracks.first.id).to eq(track.id)
      expect(@scheduled_show.prerecord_track_id).to eq(track.id)
      @scheduled_show.use_prerecorded_file_for_archive = true
      @scheduled_show.save!
      expect(@scheduled_show.tracks.first).to eq track
    end
  end
end
