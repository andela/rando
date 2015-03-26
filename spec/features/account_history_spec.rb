require 'rails_helper'

feature 'Users sees his account history' do
  before do
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(User).to receive(:create_account).and_return("account_id")

    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit '/'
    click_on 'Login'
  end

  scenario 'users sees his 3 of his most recent transactions' do
    user = User.where(email: 'christopher@andela.co').first
    create(:journal_entry, user: user, account_id: user.account_id)
    click_on 'My Andonation'
    expect(page).to have_content('for a job well done')
    expect(page).to have_content('credit')
    expect(page).to have_content(user.name)
    expect(page).to have_content('credit')
    expect(page).to have_content('1')
  end
end