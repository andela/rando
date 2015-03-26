require 'rails_helper'

describe SupportsController, type: :controller do
  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }

  before do
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    before do
      allow_any_instance_of(FundManager).to receive(:balance).and_return('200')
    end

    it 'assigns campaign' do
      needed_rem = campaign.needed - campaign.raised

      xhr :get, :new, campaign_id: campaign
      expect(assigns(:needed)).to eq(needed_rem)
      expect(assigns(:user_balance)).to eq('200')
    end

    it 'renders support modal window' do
      xhr :get, :new, campaign_id: campaign
      expect(response).to render_template('supports/new')
    end
  end

  describe 'POST #create' do
    before do
      allow_any_instance_of(FundManager).to receive(:balance).and_return("400")
      allow_any_instance_of(UserFundManager).to receive(:allocate_campaign).and_return(202)
    end

    it 'supports a campaign' do
      xhr :post, :create, campaign_id: campaign, raised: '300'
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