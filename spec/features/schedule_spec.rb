require 'rails_helper'

def visit_schedule_path
  visit "/schedule"
end

def fill_in_schedule_form show, start_at, end_at
  select show.title, from: "scheduled_show_show_id"
  select_date start_at, from: "scheduled_show_start_at"
  select_date end_at, from: "scheduled_show_end_at"
end

def i_should_see_my_scheduled_show show, start_at, end_at
  expect(page).to have_content show.title
end

def click_on_show show
  find("span", :text => show.title).click
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
  let!(:show) { FactoryGirl.create :show, radio: radio, title: "my cool show", dj: dj, image: File.new("spec/fixtures/images/pineapple.png") }
  before do
    owner.radios << radio
    dj.radios << radio
    subscription.radios << radio
  end
  scenario 'non-logged in user can view schedule'
  scenario 'logged in user views schedule in their timezone'
  scenario 'dj can schedule their show' do
    login_as dj
    visit_schedule_path
    fill_in_schedule_form show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_button "Add show"
    i_should_see_my_scheduled_show show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
  end
  scenario 'dj can edit their scheduled show' do
    login_as dj
    visit_schedule_path
    fill_in_schedule_form show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_button "Add show"
    i_should_see_my_scheduled_show show, Chronic.parse("today at 3pm"), Chronic.parse("today at 5pm")
    click_on_show show
    click_link "Edit"
    fill_in_schedule_form show, Chronic.parse("today at 5pm"), Chronic.parse("today at 7pm")
    click_button "Add show"
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
