require 'rails_helper'

feature 'Homepage' do

  scenario 'User visits homepage' do
    visit '/'

    expect(page).to have_content('Andonation')
    within '.navbar' do
      expect(page).to have_link('Andonation', href: '/')
    end
  end
end