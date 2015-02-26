require 'rails_helper'

describe CampaignsController,  type: :controller do
  describe 'methods allowed for authenticated user' do
    let(:user) { create(:user) }

    before do
      allow(request.env['warden']).to receive(:authenticate!) { user }
      allow(controller).to receive(:current_user) { user }
    end

    describe '#new' do
      it 'assigns @campaign' do
        get :new
        expect(assigns(:campaign)).to be_a_new(Campaign)
      end
    end

    describe '#create' do
      it 'assigns @campaign' do
        post :create, campaign: attributes_for(:campaign)
        expect(assigns(:campaign)).to eq(Campaign.last)
      end

      context 'has valid fields' do
        it 'creates a new campaign' do
          expect{
            post :create, campaign: attributes_for(:campaign)
          }.to change(Campaign, :count).by(1)
        end

        it 'redirects to the campaign page' do
          post :create, campaign: attributes_for(:campaign)
          expect(response).to redirect_to Campaign.last
        end
      end

      context 'has invalid fields' do
        it 'does not save the new campaign' do
          expect {
            post :create, campaign: attributes_for(:invalid_campaign)
          }.to_not change(Campaign, :count)
        end

        it 're-renders the new action' do
          post :create, campaign: attributes_for(:invalid_campaign)
          expect(response).to render_template :new
        end
      end
    end

    describe '#show' do
      it 'assigns campaign' do
        campaign = create(:campaign)
        get :show, id: campaign
        expect(assigns(:campaign)).to eq(campaign)
      end

      it 'renders the show template' do
        get :show, id: create(:campaign)
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      let(:campaign) { create(:campaign, user: user) }

      it 'assigns campaign' do
        get :edit, id: campaign
        expect(assigns(:campaign)).to eq(campaign)
      end

      it 'renders edit template' do
        get :edit, id: campaign
        expect(response).to render_template :edit
      end
    end

    describe 'PUT #update' do
      let(:campaign) { create(:campaign, user: user) }

      context 'valid attributes' do
        it 'locates the requested campaign' do
          put :update, id: campaign, campaign: attributes_for(:campaign)
          expect(campaign).to eq(campaign)
        end

        it 'changes the campaigns attributes' do
          put :update, id: campaign, campaign: attributes_for(:campaign, title: 'Pizza for everybody')
          campaign.reload
          expect(campaign.title).to eq('Pizza for everybody')
        end

        it 'redirect to the updated campaign page' do
          put :update, id: campaign, campaign: attributes_for(:campaign)
          expect(response).to redirect_to campaign
        end
      end

      context 'invalid fields' do
        it 're-renders the edit action' do
          put :update, id: campaign, campaign: attributes_for(:invalid_campaign)
          expect(response).to render_template :edit
        end
      end
    end

    describe'DELETE#destroy'do
      let!(:campaign) { create(:campaign, user: user) }

      it "deletes the contact" do
        expect{
          delete :destroy, id: campaign
        }.to change(Campaign, :count).by(-1)
      end

      it "redirects to my andonation" do
        delete :destroy, id: campaign
        expect(response).to redirect_to my_andonation_path
      end
    end
  end

  describe 'Get #index' do
    let!(:campaigns) { create_list(:campaign, 3).reverse! }

    it 'assigns @campaigns' do
      get :index
      expect(assigns(:campaigns)).to eq(campaigns)
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'methods not allowed for unauthenticated user' do
    it_should_behave_like "an unauthenticated user", [[:get, :new], [:post, :create]]
  end
end