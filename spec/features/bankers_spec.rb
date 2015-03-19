require 'rails_helper'

feature 'Bankers make deposit' do
  let(:transaction) { Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[0]) }
  scenario 'User with bankers role', js: true do

    res = double("response", code: 202)
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(BankFundManager).to receive(:deposit).and_return(res)
    allow_any_instance_of(User).to receive(:create_account).and_return("account_id")
    allow_any_instance_of(BankFundManager).to receive(:user_transactions).and_return([transaction])
    allow_any_instance_of(FundManager).to receive(:transactions).and_return([transaction])

    user = create(:user, email:'christopher@andela.co')
    user.add_role :banker
    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit '/'
    click_on 'Login'
    click_on 'My Andonation'
    click_on 'Bankers Page'
    click_on 'Deposit $'
    within("#modal-window") do
      fill_in 'amount', with: '100'
      click_on 'Deposit'
    end
    expect(page).to have_content('Credit')
    expect(page).to have_content('100')
    expect(page).to have_content('christopher@andela.co')

    OmniAuth.config.test_mode = false
  end
end