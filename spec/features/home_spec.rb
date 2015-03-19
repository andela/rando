require 'rails_helper'

feature 'Campaigns exists' do
  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
  end
  let!(:campaign) { create(:campaign, title: 'Science and Tech', deadline: Date.tomorrow + 1, needed: '320000', description: 'New innovation comes out daily', raised: '24000') }

  scenario 'User visits homepage and sees current campaigns' do
    visit '/'

    expect(page).to have_content('Andonation')
    within '.navbar' do
      expect(page).to have_link('Andonation', href: '/')
    end

    expect(page).to have_content('Current Campaigns')
    expect(page).to have_link('Science and Tech')
    expect(page).to have_content((Date.tomorrow + 1).strftime('%Y-%m-%d'))
    expect(page).to have_content('$320000')
    expect(page).to have_content('$24000')
    expect(page).to have_content('New innovation comes out daily')
  end
end

feature 'No Campaigns' do
  scenario 'User visits homepage and sees no current campaigns' do
    visit '/'

    within '.no-campaigns' do
      expect(page).to have_content('There are no active campaigns currently running')
    end
  end
end