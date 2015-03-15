require 'rails_helper'

feature 'Distributors allocates money to users', js: :true do
  scenario 'User with distributor role shares money' do
    allow_any_instance_of(SubledgerClient).to receive(:balance).and_return(100)
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
    allow_any_instance_of(SubledgerClient).to receive(:allocate).and_return(202)
    usr = create(:user)
    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit '/'
    click_on 'Login'
    user = User.where( email:'christopher@andela.co' ).first
    user.add_role :distributor
    user.add_role :admin

    visit '/users/distribute'
    find(:css, "#users_ids_[value='#{usr.id}']").set(true)
    click_on 'Allocate Money'
    within("#modal-window") do
      fill_in 'amount', with: 100
      click_on 'Allocate'
    end

    expect(page).to have_content('Money distributed successfully')
  end
end