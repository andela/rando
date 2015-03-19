require 'rails_helper'

feature 'Campaigns' do
  let(:transaction) { Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[0]) }
  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
    allow_any_instance_of(SubledgerClient).to receive(:transactions).and_return([transaction])
    allow_any_instance_of(SubledgerClient).to receive(:balance).and_return(200)
  end

  feature 'user manages his campaigns' do
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
      fill_in 'Funding Deadline', with: (Date.tomorrow + 1.day).strftime('%Y/%m/%d')
      fill_in 'How much do you need to raise?', with: 20000
      fill_in 'Description', with: 'Feed the hungry children with plenty food. Make them happy!'
      fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo'
      expect(page).to_not have_link('Delete Campaign')
      click_on 'Create Campaign'
      expect(page).to have_content('Campaign was successfully created.')

      expect(page).to have_content('PLANTAINS FOR THE POOR')
      expect(page).to have_content("Created by: #{@logged_user}")
      expect(page).to have_content("Deadline: #{(Date.tomorrow + 1.day).strftime('%Y/%m/%d')}")
      expect(page).to have_content('Needs: $20000')
      expect(page).to have_content('Feed the hungry children with plenty food. Make them happy!')
      expect(page).to have_css ("iframe[src='https://www.youtube.com/embed/abcdefghiklmo']")

      click_on 'Edit Campaign'
      expect(page).to have_field('Title', with: 'plantains for the poor')
      expect(page).to have_field('Funding Deadline', with: (Date.tomorrow + 1.day))
      expect(page).to have_field('How much do you need to raise?', with: 20000)
      expect(page).to have_field('Description', with: 'Feed the hungry children with plenty food. Make them happy!')
      expect(page).to have_field('YouTube URL', with: 'https://www.youtube.com/watch?v=abcdefghiklmo')

      fill_in 'Title', with: 'Bananas for the rich'
      fill_in 'Funding Deadline', with: (Date.tomorrow + 2.day).strftime('%Y/%m/%d')
      fill_in 'How much do you need to raise?', with: 500000
      fill_in 'Description', with: 'Feed the fat children with plenty bananas. Make them not so happy!'
      fill_in 'YouTube URL', with: 'https://www.youtube.com/watch?v=a4AOHOdJ1Bk'
      click_on 'Update Campaign'
      expect(page).to have_content('Campaign was successfully updated.')

      click_on 'Edit Campaign'
      click_on 'Delete Campaign'
      expect(page).to have_content('Campaign was successfully deleted.')
      click_on 'Logout'
      expect(page).not_to have_link('Add Campaign')
    end

    scenario 'visitor sees more campaigns' do
      create_list(:campaign, 21)
      stub_const('Campaign::DISPLAY_COUNT', 20)
      visit '/campaigns'

      click_on 'Next'
      expect(page).to have_content('Food for the Poor')
      expect(page).to have_content((Date.tomorrow + 1.day).strftime('%Y-%m-%d'))
      expect(page).to have_content('6000')
      expect(page).to have_content('Never go hungry again.')
      expect(page).to have_link('First')
    end

    scenario 'user clicks in datepicker field', driver: :selenium do
      find_field('Deadline').click
      expect(page).to have_content(Date.tomorrow.day)
      click_on 'Close'
    end
  end

  feature 'User views all campaigns' do
    scenario 'user sees all the campaigns on the system' do
      create_list(:campaign, 3)
      visit '/'
      click_on 'See all 3 open campaigns'
      expect(page).to have_content('Food for the Poor')
      expect(page).to have_content("Deadline: #{(Date.tomorrow + 1.day)}")
      expect(page).to have_content('Needs: $60000')
    end
  end

  feature 'User can only edit his own campaigns' do
    background do
      OmniAuth.config.test_mode = true
      set_valid_omniauth

      visit root_path
      click_on 'Login'
    end

    given(:user_one) { create(:user) }
    given(:user_two) { create(:user) }
    given!(:campaign_one) { create(:campaign, user: user_one) }

    scenario 'user cannot edit others campaigns' do
      visit '/campaigns'
      click_on campaign_one.title
      expect(page).not_to have_link('Edit Campaign')
    end
  end
end