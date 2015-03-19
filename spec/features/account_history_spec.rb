require 'rails_helper'

feature 'Users sees his account history' do
  let(:transaction) { Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[0]) }

  before do
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(User).to receive(:create_account).and_return("account_id")
    allow_any_instance_of(FundManager).to receive(:transactions).and_return([transaction])

    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit '/'
    click_on 'Login'
    click_on 'My Andonation'
  end

  scenario 'users sees his 3 of his most recent transactions' do
    expect(page).to have_content('My Account History')
    expect(page).to have_content('christopher@andela.co')
    expect(page).to have_content('2015-03-07')
    expect(page).to have_content('Credit')
    expect(page).to have_content('100')
  end
end