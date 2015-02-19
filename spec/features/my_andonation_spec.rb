require 'rails_helper'

feature 'campaigns' do
  scenario 'authenticated user sees his campaigns' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    campaign = create(:campaign, user: User.first)
    visit root_path
    click_on 'Login'
    click_on 'My Andonation'
    expect(page).to have_content('My Campaigns')
    expect(page).to have_content('Food for the Poor')
    expect(page).to have_content(Date.tomorrow.strftime('%Y-%m-%d'))
    expect(page).to have_content('6000')
    click_on 'Food for the Poor'
    expect(page).to have_content('Never go hungry again.')
  end
end