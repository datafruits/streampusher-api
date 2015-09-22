require 'rails_helper'

# VCR.configure do |config|
#   config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
#   config.hook_into :webmock # or :fakeweb
# end

def visit_playlists_path
  visit "/playlists"
end

def upload_a_track
  attach_file "file", File.join(Rails.root,"spec/fixtures/the_cowbell.mp3")
end

def create_a_new_playlist
  fill_in "playlist[name]", with: "my new playlist"
  click_button "+ new playlist"
end

def drag_track_to_playlist
  track = page.find_by_id('tracks').find('li.track')
  playlist = page.find_by_id('playlists').find('li.playlist').find("ul.playlist-tracks")
  track.drag_to(playlist)
end

def remove_track_from_playlist
  within "ul.playlist-tracks" do
    find("button.delete-from-playlist").click
  end
end

def click_edit_track_button
  within "ul#tracks" do
    find("a.edit-track").click
  end
end

def edit_id3_tags tags
  fill_in "track[artist]", with: tags[:artist]
  click_button "Save changes"
end

def click_delete_track_button
  within "ul#tracks" do
    find("a.delete-track").click
  end
  page.accept_alert
end

def click_edit_playlist_button
  within "ul#playlists" do
    find("a.edit-playlist").click
  end
end

def edit_playlist_name new_name
  fill_in "playlist[name]", with: new_name
  click_button "Save changes"
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
    expect(page).to have_content('track uploaded!')
    expect(page).to have_content('the_cowbell.mp3')
  end

  scenario 'adding and removing tracks to playlists' do
    login_as @owner
    visit_playlists_path
    upload_a_track
    create_a_new_playlist
    expect(page).to have_content('created playlist')
    drag_track_to_playlist
    expect(page).to have_content('added track to playlist!')
    remove_track_from_playlist
    expect(page).to have_content('removed track from playlist!')
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
    expect(page).to have_content('track uploaded!')
    expect(page).to have_content('the_cowbell.mp3')
    click_delete_track_button
    expect(page).to have_content "removed track!"
  end

  scenario 'edit playlist' do
    login_as @owner
    visit_playlists_path
    create_a_new_playlist
    expect(page).to have_content('created playlist')
    click_edit_playlist_button
    edit_playlist_name "new playlist name"
    expect(page).to have_content "new playlist name"
  end
end
