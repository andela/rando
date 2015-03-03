require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  context 'admin manages user' do
    let(:user) { create(:user) }

    before do
      user.add_role :admin
    end

    it { is_expected.to be_able_to(:read, User) }
  end
end