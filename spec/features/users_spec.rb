require 'rails_helper'

feature 'Signup/Login user' do

  scenario 'user logs in and sees My Andonation link' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit root_path
    click_on 'Login'
    expect(page).to have_content('Successfully authenticated from Google account.')
    expect(page).to have_link('My Andonation', href: '/')
    click_on 'Logout'
    expect(page).to have_content('Signed out successfully.')
    expect(page).not_to have_link('My Andonation', href: '/')
  end
end