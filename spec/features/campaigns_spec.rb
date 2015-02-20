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

    click_on 'Create Campaign'
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Deadline can't be blank")
    expect(page).to have_content("Amount can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Youtube url can't be blank")

    expect(page).to have_content('New Campaign')
    fill_in 'Title', with: 'plantains for the poor'
    fill_in 'Funding Deadline', with: Date.tomorrow.strftime('%Y/%m/%d')
    fill_in 'How much do you need to raise?', with: 20000.0
    fill_in 'Description', with: 'Feed the hungry children with plenty food. Make them happy!'
    fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo'
    click_on 'Create Campaign'
    expect(page).to have_content('Campaign was successfully created.')

    expect(page).to have_content('PLANTAINS FOR THE POOR')
    expect(page).to have_content("Created by: #{@logged_user}")
    expect(page).to have_content("Deadline: #{Date.tomorrow.strftime('%Y/%m/%d')}")
    expect(page).to have_content('Needs: $20000.0')
    expect(page).to have_content('Feed the hungry children with plenty food. Make them happy!')
    expect(page).to have_css ("iframe[src='https://www.youtube.com/embed/abcdefghiklmo']")

    click_on 'Edit Campaign'
    expect(page).to have_field('Title', with: 'plantains for the poor')
    expect(page).to have_field('Funding Deadline', with: Date.tomorrow)
    expect(page).to have_field('How much do you need to raise?', with: 20000.0)
    expect(page).to have_field('Description', with: 'Feed the hungry children with plenty food. Make them happy!')
    expect(page).to have_field('YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo')

    fill_in 'Title', with: 'Bananas for the rich'
    fill_in 'Funding Deadline', with: (Date.tomorrow + 1.day).strftime('%Y/%m/%d')
    fill_in 'How much do you need to raise?', with: 500000.0
    fill_in 'Description', with: 'Feed the fat children with plenty bananas. Make them not so happy!'
    fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=a4AOHOdJ1Bk'
    click_on 'Update Campaign'
    expect(page).to have_content('Campaign was successfully updated.')

    click_on 'Logout'
    expect(page).not_to have_link('Add Campaign')
  end

  scenario 'user clicks in datepicker field', driver: :selenium do
    find_field('Deadline').click
    expect(page).to have_content(Date.tomorrow.day)
    click_on 'Close'
  end
end