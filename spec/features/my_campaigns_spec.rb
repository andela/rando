require 'rails_helper'

feature 'My Campaigns' do
  scenario 'Authenticated user sees all his campaigns' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    create(:campaign, title: 'Eat like a King', user: User.first)
    create_list(:campaign, 4, user: User.first)

    visit '/'
    click_on 'Login'

    visit '/my_campaigns'
    expect(page).to have_content('Eat like a King')

    click_on 'Eat like a King'
    expect(page).to have_content('Never go hungry again.')
  end

  scenario 'authenticated user sees message if no current campaigns' do
    visit '/'

    click_on 'Login'
    visit '/my_campaigns'
    expect(page).to have_content('You have no active campaigns currently running')
  end
end