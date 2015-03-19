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

      post :create, users: "#{user.id}"
      expect(flash[:notice]).to eq('Money distributed successfully')
    end
  end
end