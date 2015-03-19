require 'rails_helper'

describe FundManager, type: :model do
  describe '#create_account' do
    it 'returns an account id' do
      manager = FundManager.new
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

      expect(manager.create_account("franklin.ugwu@andela.co")).to eq("iDFQmJjGUgXC6ecn7zZxc6")
    end
  end

  describe '#transactions' do
    it 'returns an array of transactions' do
      manager = FundManager.new
      res = double("response", body: sample_transaction_api_response_debit)
      transaction = Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[1])

      expect(SubledgerClient).to receive(:get) { res }
      result_transaction = manager.transactions("").first
      expect(result_transaction.amount).to eq(transaction.amount)
      expect(result_transaction.transaction_type).to eq(transaction.transaction_type)
      expect(result_transaction.posted_at).to eq(transaction.posted_at)
      expect(result_transaction.email).to eq(transaction.email)
    end
  end

  describe '#balance' do
    it 'returns the system balance' do
      manager = FundManager.new
      res = double("response", body: balance)

      expect(SubledgerClient).to receive(:get) { res }
      expect(manager.balance("account")).to eq("34160")
    end
  end
end