require 'rails_helper'

describe UserDecorator do
  describe '#pretty_roles' do
    let(:user) { create(:user).decorate }

    before do
      user.add_role :admin
      user.add_role :banker
    end

    it 'sorts the roles in alphabetical order' do
      expect(user.pretty_roles).to eq('Admin, Banker, Member')
    end
  end

  describe '#balance' do
    let(:user) { create(:user).decorate }

    it 'returns the balance of user' do
      allow_any_instance_of(SubledgerClient).to receive(:balance).and_return(100)
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")

      expect(user.balance).to eq(100)
    end
  end
end