require 'rails_helper'

feature 'Signup/Login user' do
  scenario 'user logs in' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit root_path
    click_on 'Login'
    expect(page).to have_content('Successfully authenticated from Google account.')
    click_on 'Logout'
    expect(page).to have_content('Signed out successfully.')
  end
end