require 'rails_helper'

feature 'campaigns' do
  background do
    OmniAuth.config.test_mode = true
    set_valid_omniauth
    @logged_user = set_valid_omniauth.info.name

    visit root_path
    click_on 'Login'
    click_on 'Add Campaign'
  end

  scenario 'authenticated user creates campaign' do
    campaign_attrs = attributes_for(:campaign)

    click_on 'Create Campaign'
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Deadline can't be blank")
    expect(page).to have_content("Amount can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Youtube url can't be blank")

    expect(page).to have_content('New Campaign')
    fill_in 'Title', with: 'plantains for the poor'
    fill_in 'Funding Deadline', with: Date.tomorrow.strftime('%Y/%m/%d')
    fill_in 'How much do you need to raise?', with: campaign_attrs[:amount]
    fill_in 'Description', with: campaign_attrs[:description]
    fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo'
    click_on 'Create Campaign'
    expect(page).to have_content('Campaign was successfully created.')

    expect(page).to have_content('PLANTAINS FOR THE POOR')
    expect(page).to have_content("Created by: #{@logged_user}")
    expect(page).to have_content("Deadline: #{Date.tomorrow.strftime('%Y/%m/%d')}")
    expect(page).to have_content("Needs: $#{campaign_attrs[:amount]}")
    expect(page).to have_content(campaign_attrs[:description])
    expect(page).to have_css("iframe[src='https://www.youtube.com/embed/abcdefghiklmo']")

    click_on 'Logout'
    expect(page).not_to have_link('Add Campaign')
  end

  scenario 'user clicks in datepicker field', driver: :selenium do
    find_field('Deadline').click
    expect(page).to have_content(Date.tomorrow.day)
    click_on 'Close'
  end
end