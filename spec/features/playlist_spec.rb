require 'rails_helper'

# VCR.configure do |config|
#   config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
#   config.hook_into :webmock # or :fakeweb
# end

def visit_playlists_path
  visit "/playlists"
end

def upload_a_track
  find(".upload", visible: false).set File.join(Rails.root,"spec/fixtures/the_cowbell.mp3")
end

def create_a_new_playlist name="my new playlist"
  find(".new-playlist-btn").click
  find(".playlist-title input").set(name)
  click_button "save-playlist"
end

def drag_track_to_playlist
  track = page.find_by_id('tracks').find('li.track')
  playlist = page.find_by_id('playlists').find('li.playlist').find("ul.playlist-tracks")
  track.drag_to(playlist)
end

def add_track_to_playlist
  find(".add-track-to-playlist").click
end

def remove_track_from_playlist
  find("button.delete-from-playlist").click
end

def click_edit_track_button
  find("button.edit-track").click
end

def edit_id3_tags tags
  find("input.track-artist").set(tags[:artist])
  click_button "Save"
end

def click_delete_track_button
  click_edit_track_button
  find(".delete-track").click
  page.accept_alert
end

def edit_playlist_name name
  find(".playlist-title").click
  find(".playlist-title input").set(name)
  click_button "save-playlist"
end

def select_playlist playlist
  find("#playlist-selector").click
  click_link playlist
end

feature 'playlists', :js => true do
  before do
    @owner =  FactoryGirl.create :owner
    @subscription = FactoryGirl.create :subscription, user: @owner
    @radio = FactoryGirl.create :radio, subscription: @subscription
    @owner.radios << @radio
  end

  scenario 'uploads a track' do
    login_as @owner
    visit_playlists_path
    upload_a_track
    expect(page).to have_content('the_cowbell.mp3')
  end

  scenario 'adding and removing tracks to playlists' do
    login_as @owner
    visit_playlists_path
    upload_a_track
    create_a_new_playlist "new playlist"
    expect(page.find("span.playlist-title")).to have_content('new playlist')
    add_track_to_playlist
    expect(page.find(".playlist-tracks")).to have_content("the_cowbell.mp3")
    remove_track_from_playlist
    expect(page.find(".playlist-tracks")).to have_no_content("the_cowbell.mp3")
  end

  scenario 'edits a track' do
    login_as @owner
    visit_playlists_path
    upload_a_track
    click_edit_track_button
    edit_id3_tags artist: "dj nameko"
    expect(page).to have_content "dj nameko"
  end

  scenario 'deletes a track' do
    login_as @owner
    visit_playlists_path
    upload_a_track
    expect(page.find(".uploaded-track-name")).to have_content('the_cowbell.mp3')
    click_delete_track_button
    expect(page).to_not have_content('the_cowbell.mp3')
  end

  scenario 'edit playlist' do
    login_as @owner
    visit_playlists_path
    create_a_new_playlist "new playlist"
    expect(page.find("span.playlist-title")).to have_content('new playlist')
    edit_playlist_name "new playlist name"
    expect(page.find("span.playlist-title")).to have_content('new playlist name')
  end

  scenario 'edit playlist settings' do
    login_as @owner
    visit_playlists_path
    create_a_new_playlist "new playlist"
    expect(page.find("span.playlist-title")).to have_content('new playlist')
    create_a_new_playlist "jingles"
    expect(page.find("span.playlist-title")).to have_content('jingles')
    select_playlist "new playlist"
    click_button "Playlist Settings"
    expect(page).to have_content("Interpolate another playlist with this one")
    page.check("interpolated-playlist-enabled")
    #find("input[name=interpolatedPlaylistEnabled]").set(true)
    fill_in "interpolatedPlaylistTrackPlayCount", with: 1
    fill_in "interpolatedPlaylistTrackIntervalCount", with: 2
    select "jingles", from: "interpolated-playlist-select"
    click_button "Save changes"
    click_button "Playlist Settings"
    expect(find("input[name=interpolatedPlaylistEnabled]")).to be_checked
    expect(page).to have_field("interpolatedPlaylistTrackPlayCount", with: 1)
    expect(page).to have_field("interpolatedPlaylistTrackIntervalCount", with: 2)
    expect(page).to have_select("interpolated-playlist-select", selected: "jingles")
  end
end
