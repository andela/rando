require 'rails_helper'

describe DistributorsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
    user.add_role :distributor
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe '#allocate_money' do
    it 'allocates money' do
      allow_any_instance_of(SubledgerClient).to receive(:allocate).and_return(202)

      post :allocate_money, users: "#{user.id}"
      expect(flash[:notice]).to eq('Money distributed successfully')
    end
  end
end