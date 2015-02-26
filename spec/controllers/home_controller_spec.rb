require 'rails_helper'

describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'assigns a list of campaigns' do
      create(:campaign) # oldest not included
      campaigns = create_list(:campaign, 3).reverse

      get :index
      expect(assigns(:campaigns)).to eq(campaigns)
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