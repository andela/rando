require 'rails_helper'

describe DistributorsController, type: :controller do
  let(:user) { create(:user) }

  before do
    user.add_role :distributor
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe '#allocate_money' do
    it 'allocates money' do
      allow_any_instance_of(UserFundManager).to receive(:allocate).and_return(202)

      post :allocate_money, users: "#{user.id}"
      expect(flash[:notice]).to eq('Money distributed successfully')
    end
  end

  describe '#withdraw_money' do
    it 'withdraws money' do
      allow_any_instance_of(UserFundManager).to receive(:withdraw).and_return(202)

      put :withdraw_money, id: "#{user.id}"
      expect(flash[:notice]).to eq('Money withdrawn successfully')
    end

    it 'displays error if distributor withdraws more than users balance' do
      allow_any_instance_of(FundManager).to receive(:balance).and_return(500)
      allow_any_instance_of(UserFundManager).to receive(:withdraw).and_return(202)

      put :withdraw_money, id: "#{user.id}", amount: 600
      expect(flash[:notice]).to eq('The maximum amount that can be withdrawn is 500')
    end
  end
end