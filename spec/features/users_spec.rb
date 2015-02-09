require 'rails_helper'

feature 'Signup/Login user' do
  before do
    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit root_path
  end

  scenario 'user logs in' do
    click_on 'Login'
    expect(page).to have_content('Successfully authenticated from Google account.')
    click_on 'Logout'
    expect(page).to have_content('Signed out successfully.')
  end

  scenario 'Authenticated user sees My Andonation link. Unauthenticated user do not see My Andonation Link' do
    click_on 'Login'
    within 'li.andonation-link' do
      expect(page).to have_link('My Andonation', href: '/')
    end
    click_on 'Logout'
      expect(page).to have_css('li.no-andonation-link')
  end
end