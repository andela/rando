require 'rails_helper'

feature 'Distributors allocates money to users', js: :true do
  background do
    allow_any_instance_of(FundManager).to receive(:balance).and_return(100)
    allow_any_instance_of(FundManager).to receive(:create_account).and_return("account_id")
    allow_any_instance_of(UserFundManager).to receive(:allocate).and_return(202)
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit '/'
    click_on 'Login'
    user = User.where( email:'christopher@andela.co' ).first
    user.add_role :distributor
    user.add_role :admin
  end

  scenario 'User with distributor role shares money' do
    usr = create(:user)
    visit '/users/distribute'
    find(:css, "#users_ids_[value='#{usr.id}']").set(true)
    click_on 'Allocate Money'
    within("#modal-window") do
      fill_in 'amount', with: 100
      fill_in 'reason', with: 'he is a good boy'
      click_on 'Allocate'
    end

    expect(page).to have_content('Money distributed successfully')
  end

  scenario 'Distributors sees users transaction history' do
    transaction = Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[0])
    allow_any_instance_of(FundManager).to receive(:transactions).and_return([transaction])
    user = create(:user)
    visit '/users/distribute'
    click_on user.first_name
    within("#modal-window") do
      expect(page).to have_content(user.name)
      expect(page).to have_content('Credit')
      expect(page).to have_content('100')
      expect(page).to have_content('christopher@andela.co')
    end
  end
 end