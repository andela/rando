require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET index' do
    let!(:users) { create_list(:user, 4) }
    let!(:user) { User.first }

    before do
      allow(request.env['warden']).to receive(:authenticate!) { user }
      allow(controller).to receive(:current_user) { user }
    end

    context 'user is not an admin' do
      it 'displays error message and redirects to root path' do
        get :index

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'user is an admin' do
      it 'assigns users' do
        user.add_role :admin
        get :index

        expect(assigns(:users)).to eq(users)
      end
    end
  end
end