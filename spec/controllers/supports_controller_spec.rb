require 'rails_helper'

describe SupportsController, type: :controller do
  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }

  before do
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    it 'assigns campaign' do
      xhr :get, :new, campaign_id: campaign
      expect(assigns(:campaign_id)).to eq(campaign.id.to_s)
    end

    it 'renders support modal window' do
      xhr :get, :new, campaign_id: campaign
      expect(response).to render_template('supports/new')
    end
  end

  describe 'POST #create' do
    before do
      allow_any_instance_of(SubledgerClient).to receive(:balance).and_return("400")
    end

    it 'supports a campaign' do
      xhr :post, :create, campaign_id: campaign, raised: '300'
      expect(assigns(:campaign_id)).to eq(campaign.id.to_s)
      expect(assigns(:raised_value)).to eq(300)
      expect(response).to redirect_to campaign
      expect(flash[:notice]).to eq('You have supported this campaign')
    end

    it 'displays error if user balance is more than amount supported' do
      xhr :post, :create, campaign_id: campaign, raised: '500'
      expect(flash[:alert]).to eq('You cannot support more than you have in your account')
    end
  end
end

