require 'rails_helper'

describe RolesHelper do
  describe '#role_checked?' do
    subject { helper.role_checked?(role) }

    before { assign(:role_names, ['admin', 'distributor']) }

    context 'role is checked' do
      let(:role) { 'admin' }
      it { is_expected.to be_truthy }
    end

    context 'role is not checked' do
      let(:role) { 'banker' }
      it { is_expected.to be_falsey }
    end
  end
end