require 'rails_helper'

def visit_schedule_path
  visit "/schedule"
end

def fill_in_schedule_form show_name, playlist, start_at, end_at
  fill_in "scheduled_show_title", with: show_name
  select playlist.name, from: "scheduled_show_playlist_id"
  select_date start_at, from: "scheduled_show_start_at"
  select_date end_at, from: "scheduled_show_end_at"
end

def i_should_see_my_scheduled_show name, start_at, end_at
  expect(page).to have_content name
end

def click_on_show name
  find("span", :text => name).click
end

def i_should_see_my_scheduled_show_deleted
  expect(page).to have_content "Deleted scheduled show!"
end

feature 'schedule', :js => true do
  let(:owner) { FactoryGirl.create :user, username: "owner", role: "owner" }
  let(:subscription) { FactoryGirl.create :subscription, user: owner }
  let(:dj) { FactoryGirl.create :user, username: "dj", role: "dj", email: "dj@gmail.com" }
  let(:radio) { FactoryGirl.create :radio, subscription: subscription }
  let!(:playlist) { FactoryGirl.create :playlist, radio: radio, name: "my playlist" }
  before do
    owner.radios << radio
    dj.radios << radio
    subscription.radios << radio
  end
  scenario 'non-logged in user can view schedule'
  scenario 'logged in user views schedule in their timezone'
  scenario 'dj can schedule their show' do
    Time.use_zone "Tokyo" do
      Timecop.travel Time.zone.parse("2020-01-01 08:00") do
        start_at = Time.zone.parse("2020-01-01 09:00")
        end_at = Time.zone.parse("2020-01-01 11:00")

        login_as dj
        visit_schedule_path
        click_link "Add show"
        fill_in_schedule_form "cool show", playlist, start_at, end_at
        click_button "Schedule show"
        expect(page.find("#calendar")).to have_content "cool show"
        i_should_see_my_scheduled_show "cool show", start_at, end_at
      end
    end
  end
  scenario 'dj can edit their scheduled show' do
    login_as dj
    visit_schedule_path
    fill_in_schedule_form "cool show", playlist, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_button "Add show"
    i_should_see_my_scheduled_show playlist, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_on_show "cool show"
    click_link "Edit"
    fill_in_schedule_form "different show", playlist, Chronic.parse("today at 5pm"), Chronic.parse("today at 7pm")
    click_button "Update show"
    i_should_see_my_scheduled_show show, Chronic.parse("today at 5pm"), Chronic.parse("today at 7pm")
  end

  scenario 'dj deletes scheduled show' do
    login_as dj
    visit_schedule_path
    fill_in_schedule_form show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_button "Add show"
    i_should_see_my_scheduled_show show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_on_show show
    click_link "Edit"
    click_link "Delete"
    page.accept_alert

    i_should_see_my_scheduled_show_deleted
  end
end
