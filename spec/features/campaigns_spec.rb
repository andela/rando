require 'rails_helper'

feature 'campaigns' do
  scenario 'authenticated user creates campaign' do
    campaign_attrs = attributes_for(:campaign)

    OmniAuth.config.test_mode = true
    set_valid_omniauth
    logged_user = set_valid_omniauth.info.name

    visit root_path
    click_on 'Login'
    click_on 'Add Campaign'
    expect(page).to have_content('New Campaign')
    fill_in 'Title', with: 'plantains for the poor'
    fill_in 'Deadline', with: campaign_attrs[:deadline]
    fill_in 'How much do you need to raise?', with: campaign_attrs[:amount]
    fill_in 'Description', with: campaign_attrs[:description]
    fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo'
    click_on 'Create Campaign'
    expect(page).to have_content('Campaign was successfully created.')

    expect(page).to have_content('PLANTAINS FOR THE POOR')
    expect(page).to have_content("Created by: #{logged_user}")
    expect(page).to have_content("Deadline: #{campaign_attrs[:deadline]}")
    expect(page).to have_content("Needs: $#{campaign_attrs[:amount]}")
    expect(page).to have_content(campaign_attrs[:description])
    expect(page).to have_css("iframe[src='https://www.youtube.com/embed/abcdefghiklmo']")

    click_on 'Logout'
    expect(page).not_to have_link('Add Campaign')
  end
end