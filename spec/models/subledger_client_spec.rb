require 'rails_helper'

describe SubledgerClient, type: :model do
  let(:client) { SubledgerClient.instance }

  describe '#balance' do
    it 'returns makes a get request' do
      expect(SubledgerClient).to receive(:get)

      client.balance("franklin.ugwu@andela.co")
    end
  end

  describe '#balance' do
    it 'returns makes a get request' do
      expect(SubledgerClient).to receive(:get)

      client.transactions("franklin.ugwu@andela.co")
    end
  end

  describe '#create_account' do
    it 'returns makes a post request' do
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

      client.create_account("franklin.ugwu@andela.co")
    end
  end

  describe '#journal_entry' do
    it 'returns makes a get request' do
      expect(SubledgerClient).to receive(:post)

      client.journal_entry('amount', 'description', 'credit_account', 'debit_account')
    end
  end
end