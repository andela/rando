require 'rails_helper'

describe TransactionsController, type: :controller do
  let(:user) { create(:user, email: 'email@andela.co') }
  let(:transaction) { create(:journal_entry) }

  before do
    create(:account, subledger_id: 'KcVEdomrdxdHK4P7QFExOi')
    user.add_role :banker
    user.add_role :distributor
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns response to system_transactions' do
      get :index
      expect(assigns(:transactions)).to eq([transaction.decorate])
    end

    it 'assigns the system balance' do
      get :index
      expect(assigns(:balance)).to eq(200)
    end
  end

  describe 'POST #deposit' do
    it 'gives a success message' do
      allow_any_instance_of(BankFundManager).to receive(:deposit).and_return(202)

      post :deposit, amount: 100
      expect(flash[:notice]).to eq('Deposit Successful')
    end
  end

  describe 'POST #withdraw' do
    it 'gives a success mesage' do
      allow_any_instance_of(BankFundManager).to receive(:withdraw).and_return(202)

      post :withdraw, amount: 200
      expect(flash[:notice]).to eq('Withdrawal Successful')
    end
  end

  describe '#user_transactions' do
    it 'assigns user' do
      xhr :get, :user_transactions, id: "#{user.id}"
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns transactions' do
      transaction = create(:journal_entry, account_id: user.account_id)
      xhr :get, :user_transactions, id: "#{user.id}"
      expect(assigns(:transactions)).to eq([transaction.decorate])
    end
  end
end
