require 'rails_helper'

describe HomeController, type: :controller do
  describe 'Displays current campaigns on homepage' do
    it 'assigns a list of campaigns' do
      create(:campaign) # oldest not included
      campaigns = create_list(:campaign, 3).reverse

      get :index
      expect(assigns(:campaigns)).to eq(campaigns)
    end

    it 'shows 3 campaigns on homepage' do
      get :index

      expect(response).to render_template :index
    end
  end
end