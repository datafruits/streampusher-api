require 'rails_helper'

RSpec.describe WikiPage, type: :model do
  it 'updates the slug when title changes' do
    user = FactoryBot.create :user
    wiki_page = WikiPage.new
    params = { title: "doo dinglius", body: "doobah" }
    wiki_page.save_new_edit! params, user.id
    expect(wiki_page.persisted?).to eq true
    expect(wiki_page.title).to eq "doo dinglius"
    expect(wiki_page.slug).to eq "doo-dinglius"

    params[:title] = "doo dinglius 2??"
    wiki_page.save_new_edit! params, user.id
    wiki_page.reload
    expect(wiki_page.title).to eq "doo dinglius 2??"
    expect(wiki_page.slug).to eq "doo-dinglius-2"
  end
end
