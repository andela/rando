require 'rails_helper'

feature 'Update Roles' do
  before do
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(FundManager).to receive(:create_account).and_return("account_id")

    OmniAuth.config.test_mode = true
    set_valid_omniauth

    visit '/'
    click_on 'Login'
    @user = User.first
    @user.add_role :admin

    click_on 'My Andonation'
    click_on 'Users'
  end

  scenario 'Admin sees all users and updates roles', js: true do
    expect(page).to have_content('Admin')
    expect(page).to have_content('Member')
    expect(page).to have_content('Christopher Columbus')

    find(:css, "#check-all").set(true)
    click_on 'Edit Roles'
    expect(page).to_not have_content('Please select a user or users')
    click_on 'Close'

    find(:css, "#check-all").set(false)
    click_on 'Edit Roles'
    expect(page).to have_content('Please select a user or users')

    find(:css, "#users_ids_[value='#{@user.id}']").set(true)
    click_on 'Edit Roles'

    expect(page).to have_content('Which roles do you want to add/remove?')
    find(:css, "#role_names_[value='banker']").set(true)
    click_on 'Save'
    expect(page).to have_content('Roles updated successfully!')
    expect(page).to have_content('Banker')
  end

  scenario 'Admin cannot remove own role', js: true do
    find(:css, "#users_ids_[value='#{@user.id}']").set(true)
    click_on 'Edit Roles'
    find(:css, "#role_names_[value='admin']").set(false)
    click_on 'Save'
    expect(page).to have_content('You cannot remove your own admin privileges!')
    expect(page).to have_content('Admin')
  end
end