require 'rails_helper'

describe HomeController, type: :controller do
  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
  end

  describe 'GET #index' do
    let!(:c_campaigns) { create_list(:campaign, 10) }
    let!(:f_campaigns) { create_list(:funded_campaign, 8) }

    it 'assigns a list of current campaigns' do
      create(:campaign)
      campaigns = create_list(:campaign, 3).reverse

      get :index
      expect(assigns(:current_campaigns)).to eq(campaigns)
    end

    it 'assigns a list of funded campaigns' do
      create(:funded_campaign)
      funded_campaigns = create_list(:funded_campaign, 3).reverse

      get :index
      expect(assigns(:funded_campaigns)).to eq(funded_campaigns)
    end

    it 'assigns @campaigns_count' do
      get :index
      expect(assigns(:current_campaigns_count)).to eq(10)
      expect(assigns(:funded_campaigns_count)).to eq(8)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end