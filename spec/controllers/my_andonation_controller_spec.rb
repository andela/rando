require 'rails_helper'

describe MyAndonationController, type: :controller do
  describe 'methods allowed for authenticated user' do
      let(:user) { create(:user) }

      before do
        allow(request.env['warden']).to receive(:authenticate!) { user }
        allow(controller).to receive(:current_user) { user }
      end

      it 'assigns a list of campaigns' do
        create(:campaign, user: user) # oldest campaign not included in result
        campaigns = create_list(:campaign, 4, user: user).reverse!

        get :index
        expect(assigns(:campaigns)).to eq(campaigns)
      end

      it 'renders the :index view' do
        get :index
        expect(response).to render_template :index
      end

      it 'checks for no current campaigns' do
        get :index
        expect(assigns(:campaigns_count)).to eq(0)
      end
  end

  describe 'methods not allowed for unauthenticated user' do
    it_should_behave_like "an unauthenticated user", [[:get, :index]]
  end
end