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
    create_a_new_playlist
    expect(page).to have_content('created playlist')
    add_track_to_playlist
    add_track_to_playlist
    remove_track_from_playlist
  end

  scenario 'edits a track' do
    visit_playlists_path
    click_edit_track_button
  end

  scenario 'deletes a track' do
    visit_playlists_path
    click_delete_track_button
  end
end
