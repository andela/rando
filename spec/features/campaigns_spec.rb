require 'rails_helper'

feature 'campaigns' do
  scenario 'authenticated user sees Add Campaign button/link' do
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit root_path
    click_on 'Login'
    expect(page).to have_link('Add Campaign')
    click_on 'Logout'
    expect(page).not_to have_link('Add Campaign')
  end
end