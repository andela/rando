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
end