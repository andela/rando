require 'rails_helper'

feature 'Bankers make deposit' do
  scenario 'User with bankers role', js: true do
    create(:account, subledger_id: 'KcVEdomrdxdHK4P7QFExOi')
    res = double("response", code: 202, body: '{
        "posting_journal_entry": {
          "id": "iDFQmJjGUgXC6ecn7zZxc6",
          "book": "tWp8ASEJApGyJvjwjW8pXl",
          "effective_at": "",
          "description": "",
          "reference": "",
          "version": 0
        }
      }')
    allow_any_instance_of(SubledgerClient).to receive(:journal_entry).and_return(res)
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(User).to receive(:create_account).and_return("account_id")
    user = create(:user, email:'christopher@andela.co')
    user.add_role :banker
    OmniAuth.config.test_mode = true
    set_valid_omniauth
    visit '/'
    click_on 'Login'
    click_on 'My Andonation'
    click_on 'Bankers'
    click_on 'Deposit $'
    within("#modal-window") do
      fill_in 'amount', with: '100'
      click_on 'Deposit'
    end
    expect(page).to have_content('credit')
    expect(page).to have_content('100')
    expect(page).to have_content('Deposit into system account')

    OmniAuth.config.test_mode = false
  end
end