require 'rails_helper'

feature 'campaigns' do
  scenario 'authenticated user sees Add Campaign button/link' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit root_path
    click_on 'Login'
    click_on 'Add Campaign'
    expect(page).to have_content('New Campaign')
    fill_in 'Title', with: 'Food for the Poor'
    fill_in 'Deadline', with: '12/12/2015'
    fill_in 'How much do you need to raise?', with: '50000'
    fill_in 'Description', with: 'Feed the homeless children'
    fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=7WJk-z5AmXk'
    expect(page).to have_button('Save')

    click_on 'Logout'
    expect(page).not_to have_link('Add Campaign')
  end

end