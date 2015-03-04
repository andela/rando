require 'rails_helper'

describe MyCampaignsController, type: :controller do
  describe 'authenticated user' do
    let(:user) { create(:user) }

    before do
      allow(request.env['warden']).to receive(:authenticate!) { user }
      allow(controller).to receive(:current_user) { user }
    end

    it 'assigns a list of current users campaigns' do
      campaigns = create_list(:campaign, 4, user: user).reverse!

      get :index
      expect(assigns(:my_campaigns)).to eq(campaigns)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'checks for no current campaigns' do
      get :index
      expect(assigns(:my_campaigns_count)).to eq(0)
    end
  end
end