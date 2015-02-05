require 'rails_helper'

describe User, type: :model do
  describe '.find_for_google_oauth2' do

    context 'user exist' do
      it 'return user' do
        User.create(email: 'christopher@andela.co')
        user = User.find_for_google_oauth2(google_oauth2_response)
        expect(user).not_to be_nil
      end
    end

    context 'user does not exist' do
      it 'creates user' do
        user = User.find_for_google_oauth2(google_oauth2_response)
        expect(user).not_to be_nil
      end
    end
  end
end
