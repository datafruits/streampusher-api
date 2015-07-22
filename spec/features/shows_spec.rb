require 'rails_helper'

def visit_shows_path
  visit shows_path
end

def fill_in_shows_form_with show
  select show[:dj], from: "show_dj_id"
  select show[:playlist].name, from: "show_playlist_id"
  attach_file "show_image", show[:image]
  fill_in "show_title", with: show[:title]
end

def click_save_button
  click_button "Save"
end

def i_should_see_show_created show
  expect(page).to have_content show[:dj]
  expect(page).to have_content show[:playlist].name
  expect(page).to have_content show[:title]
  expect(page).to have_content "Successfully created show."
end

def click_edit_button show
  click_link "Edit"
end

feature 'shows' do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let(:subscription) { FactoryGirl.create :subscription, user: owner }
  let(:dj) { FactoryGirl.create :user, username: "dj", role: "dj", email: "dj@gmail.com" }
  let(:radio) { FactoryGirl.create :radio, subscription: subscription }
  let(:playlist) { FactoryGirl.create :playlist, radio: radio, name: "my playlist" }
  before do
    owner.radios << radio
    dj.radios << radio
    subscription.radios << radio
  end
  scenario 'owner can create shows' do
    show = { dj: "owner", playlist: playlist, image: "spec/fixtures/images/pineapple.png", title: "my cool show" }
    login_as owner
    visit_shows_path
    fill_in_shows_form_with show
    click_save_button
    i_should_see_show_created show
  end
  scenario 'owner can edit shows' do
    show = { dj: "owner", playlist: playlist, image: "spec/fixtures/images/pineapple.png", title: "my cool show" }
    login_as owner
    visit_shows_path
    fill_in_shows_form_with show
    click_save_button
    i_should_see_show_created show
    click_edit_button show
    change_show_title "my cooler show"
    click_save_button
    i_should_see_show_updated "my cooler show"
  end
  scenario 'dj can create shows on their radio'
  scenario 'dj can edit shows on their radio'
end
