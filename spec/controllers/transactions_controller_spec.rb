require 'rails_helper'

describe TransactionsController, type: :controller do
  let(:user) { create(:user, email: 'email1@andela.co') }
  let(:transaction) { Transaction.new(ActiveSupport::JSON.decode(expected_transactions)) }

  before do
    user.add_role :banker
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    before do
      allow_any_instance_of(SubledgerClient).to receive(:transactions).and_return(transaction)
      allow_any_instance_of(SubledgerClient).to receive(:balance).and_return("200")
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns response to system_transactions' do
      get :index
      expect(assigns(:transactions)).to eq(transaction)
    end

    it 'assigns the system balance' do
      get :index
      expect(assigns(:balance)).to eq("200")
    end
  end

  describe 'POST #deposit' do
    it 'gives a success message' do

      stub_request(:post, "https://2lzQysbyNXhPgYxx8pp2vE:CJzZPwRw01thgquyeD6RYc@api.subledger.com/v2/orgs/EpXxbhcVpxyC8BH0icuIQF/books/tWp8ASEJApGyJvjwjW8pXl/journal_entries/create_and_post").
          with(:body => /effective_at*/,
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 202, :body => "", :headers => {})

      post :deposit, amount: 100
      expect(flash[:notice]).to eq('Deposit Successful')
    end
  end

  describe 'POST #withdraw' do
    it 'gives a success mesage' do
      stub_request(:post, "https://2lzQysbyNXhPgYxx8pp2vE:CJzZPwRw01thgquyeD6RYc@api.subledger.com/v2/orgs/EpXxbhcVpxyC8BH0icuIQF/books/tWp8ASEJApGyJvjwjW8pXl/journal_entries/create_and_post").
          with(:body => /effective_at*/,
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 202, :body => "", :headers => {})

      post :withdraw, amount: 200
      expect(flash[:notice]).to eq('Withdrawal Successful')
    end
  end

  def sample_transaction_api_response
    '{
        "posted_lines": [
          {
            "id": "wrlFLCuz7cDldBUoUrlvDQ",
            "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
            "account": "vsfM9fHDnEB6J8jHliNTKq",
            "description": "franklin.ugwu@andela.co",
            "reference": "http://www.andela.co/",
            "value": {
              "type": "debit",
              "amount": "100"
            },
            "order": "0001.00",
            "version": 1,
            "effective_at": "2014-08-01T01:02:50.000Z",
            "posted_at": "2015-03-07T23:34:12.244Z",
            "balance": {
              "debit_value": {
                "type": "debit",
                "amount": "100"
              },
              "credit_value": {
                "type": "zero",
                "amount": "0"
              },
              "value": {
                "type": "debit",
                "amount": "100"
              }
            }
          }
        ]
      }
    '
  end

  def expected_transactions
    '
    [
      {
        "id": "wrlFLCuz7cDldBUoUrlvDQ",
        "journal_entry": "nGM69VE1GUc9QqeZ9jfmgV",
        "account": "vsfM9fHDnEB6J8jHliNTKq",
        "description": "franklin.ugwu@andela.co",
        "reference": "http://www.andela.co/",
        "value": {
          "type": "debit",
          "amount": "100"
        },
        "order": "0001.00",
        "version": 1,
        "effective_at": "2014-08-01T01:02:50.000Z",
        "posted_at": "2015-03-07T23:34:12.244Z",
        "balance": {
          "debit_value": {
            "type": "debit",
            "amount": "100"
          },
          "credit_value": {
            "type": "zero",
            "amount": "0"
          },
          "value": {
            "type": "debit",
            "amount": "100"
          }
        }
      }
    ]
    '
  end

  def t_balance
    '
    {
  "balance": {
    "debit_value": {
      "type": "debit",
      "amount": "283538"
    },
    "credit_value": {
      "type": "credit",
      "amount": "246343"
    },
    "value": {
      "type": "debit",
      "amount": "37195"
    }
  }
}
    '
  end
end
