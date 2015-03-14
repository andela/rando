require 'rails_helper'

describe User, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }

  describe '.find_for_google_oauth2' do

    context 'user exist' do
      it 'return existing user' do
        existing_user = create(:user)
        google_oauth2_response = build_google_oauth2_response(existing_user.email)
        user = User.find_for_google_oauth2(google_oauth2_response)
        expect(user).to eq(existing_user)
      end
    end

    context 'user does not exist' do
      it 'creates user' do
        user = User.find_for_google_oauth2(build_google_oauth2_response)
        expect(user).not_to be_nil
      end
    end

    context 'bad response from google' do
      it 'returns nil' do
        bad_response = :invalid_credentials
        result = User.find_for_google_oauth2(bad_response)
        expect(result).to be_nil
      end
    end
  end

  describe '.google_response_valid?' do
    context 'invalid response from google' do
      it 'returns false' do
        response = :invalid_credentials
        result = User.google_response_valid?(response)
        expect(result).to be_falsey
      end
    end

    context 'valid response from google' do
      it 'returns true' do
        google_oauth2_response = build_google_oauth2_response
        result = User.google_response_valid?(google_oauth2_response)
        expect(result).to be_truthy
      end
    end
  end

  describe '#add_member_role' do
    let(:user) { create(:user) }

    it 'user has member role' do
      expect(user).to have_role :member
    end
  end

  describe '#create_account' do
    let(:user) { create(:user) }

    it 'user has an account' do
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
      expect(user.account_id).to eq("account_id")
    end
  end

  describe '#update_roles' do
    let(:users) { create_list(:user, 3) }
    let(:admin) {users.first}

    before do
      admin.add_role :admin
      admin.add_role :banker
      users.second.add_role :banker
      users.third.add_role :admin
      users_ids = users.map(&:id).split(' ')
      selected_roles = ['banker', 'distributor']
      User.update_roles(users_ids, selected_roles, admin)
    end

    it 'removes a role' do
      user = create(:user)
      user.remove_role :banker
      expect(user).to_not have_role :banker
      expect(admin).to have_role :admin
    end

    it 'updates roles of users' do
      users.each do |user|
        expect(user).to have_role(:banker)
        expect(user).to have_role(:distributor)
      end
    end

    it 'should not be able to remove admin role from the current user' do
      expect { raise StandardError }.to raise_error
      expect(admin).to have_role(:admin)
    end
  end
end