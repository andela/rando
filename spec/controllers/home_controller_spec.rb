require 'rails_helper'

describe HomeController, type: :controller do
  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
  end

  describe 'GET #index' do
    it 'assigns a list of current campaigns' do
      create(:campaign) # oldest not included
      campaigns = create_list(:campaign, 3).reverse

      get :index
      expect(assigns(:current_campaigns)).to eq(campaigns)
    end

    it 'assigns @campaigns_count' do
      allow(Campaign).to receive(:count) { 10 }

      get :index
      expect(assigns(:campaigns_count)).to eq(10)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end