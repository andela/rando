require 'rails_helper'

feature 'Homepage' do
  let!(:campaign) { create(:campaign, title: 'Science and Tech', deadline: Date.tomorrow + 1, amount: '320000', description: 'New innovation comes out daily') }

  scenario 'User visits homepage' do
    visit '/'

    expect(page).to have_content('Andonation')
    within '.navbar' do
      expect(page).to have_link('Andonation', href: '/')
    end

    expect(page).to have_content('Current Campaigns')
    expect(page).to have_link('Science and Tech')
    expect(page).to have_content((Date.tomorrow + 1).strftime('%Y-%m-%d'))
    expect(page).to have_content('$320000')
    expect(page).to have_content('New innovation comes out daily')
  end
end