require 'rails_helper'

feature 'Roles' do
  scenario 'User with bankers role', js: true do
    stub_request(:get, /.*KcVEdomrdxdHK4P7QFExOi\/lines*/).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => sample_transaction_api_response, :headers => {})

    stub_request(:get, /.*KcVEdomrdxdHK4P7QFExOi\/balance*/).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => balance, :headers => {})

    stub_request(:post, "https://2lzQysbyNXhPgYxx8pp2vE:CJzZPwRw01thgquyeD6RYc@api.subledger.com/v2/orgs/EpXxbhcVpxyC8BH0icuIQF/books/tWp8ASEJApGyJvjwjW8pXl/journal_entries/create_and_post").
        with(:body => /effective_at*/,
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => expected_transactions, :headers => {})

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