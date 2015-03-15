require 'rails_helper'

describe SubledgerClient, type: :model do

  describe '#transactions' do
    it 'returns status code of 202' do
      client = SubledgerClient.new
      res = double("response", body: sample_transaction_api_response)
      transaction = Transaction.new(ActiveSupport::JSON.decode(expected_transactions))

      expect(SubledgerClient).to receive(:get) { res }
      result_transaction = client.transactions.first
      expect(result_transaction.amount).to eq(transaction.amount)
      expect(result_transaction.transaction_type).to eq(transaction.transaction_type)
      expect(result_transaction.posted_at).to eq(transaction.posted_at)
      expect(result_transaction.email).to eq(transaction.email)
    end
  end

  describe '#balance' do
    it 'returns the system balance' do
      client = SubledgerClient.new
      res = double("response", body: balance)

      expect(SubledgerClient).to receive(:get) { res }
      expect(client.balance("account")).to eq("34160")
    end
  end

  describe '#deposit' do
    it 'returns status code of 202' do
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
      client = SubledgerClient.new
      current_user = create(:user)
      res = double("response", code: "202")

      allow(client).to receive(:execute_transaction) { res }
      expect(client.deposit('200', current_user)).to eq("202")
    end
  end

  describe '#withdraw' do
    it 'returns status code of 202' do
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
      client = SubledgerClient.new
      current_user = create(:user)
      res = double("response", code: "202")

      allow(client).to receive(:execute_transaction) { res }
      expect(client.withdraw('200', current_user)).to eq("202")
    end
  end

  describe '#user_transactions' do
    it 'returns status code of 202' do
      client = SubledgerClient.new
      transaction = Transaction.new(ActiveSupport::JSON.decode(expected_transactions))
      allow(client).to receive(:transactions) { [transaction] }

      expect(client.user_transactions('franklin.ugwu@andela.co')[0]).to eq(transaction)
    end
  end

  describe '#create_account' do
    it 'returns and account id' do
      client = SubledgerClient.new
      res = double("response", body: '{
                          "active_account": {
                            "id": "iDFQmJjGUgXC6ecn7zZxc6",
                            "book": "tWp8ASEJApGyJvjwjW8pXl",
                            "description": "example@andela.co",
                            "reference": "http://www.andela.co/",
                            "normal_balance": "credit",
                            "version": 1
                          }
                        }')
      expect(SubledgerClient).to receive(:post) { res }

      expect(client.create_account("franklin.ugwu@andela.co")).to eq("iDFQmJjGUgXC6ecn7zZxc6")
    end
  end

  describe '#allocate' do
    it 'return status 202 code' do
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
      user = create(:user)
      client = SubledgerClient.new
      res = double("response", body: '{
                          "active_account": {
                            "id": "iDFQmJjGUgXC6ecn7zZxc6",
                            "book": "tWp8ASEJApGyJvjwjW8pXl",
                            "description": "example@andela.co",
                            "reference": "http://www.andela.co/",
                            "normal_balance": "credit",
                            "version": 1
                          }
                        }',
      code: 202)

      expect(SubledgerClient).to receive(:post) { res }

      expect(client.allocate([user.id], 12, user)).to eq(202)
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
    '

  end
  def balance
    '
    {
  "balance": {
    "debit_value": {
      "type": "debit",
      "amount": "295527"
    },
    "credit_value": {
      "type": "credit",
      "amount": "261367"
    },
    "value": {
      "type": "debit",
      "amount": "34160"
    }
  }
}
    '
  end

end