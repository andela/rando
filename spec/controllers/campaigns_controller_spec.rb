require 'rails_helper'

describe CampaignsController,  type: :controller do
  describe '#new' do
    let(:user) { User.create(email: 'christopher@andela.co') }

    it 'assigns @campaign' do
      allow(controller).to receive(:current_user) { user }
      get :new
      expect(assigns(:campaign)).to be_new_record
    end
  end
end