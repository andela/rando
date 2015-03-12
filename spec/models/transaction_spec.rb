require 'rails_helper'

describe Transaction, type: :model do
  let(:transaction) { Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[0]) }

  describe 'Transaction methods' do
    it 'returns the transaction type' do
      expect(transaction.transaction_type).to eq('Credit')
    end

    it 'returns the date of transaction' do
      expect(transaction.posted_at).to eq('2015-03-07')
    end

    it 'returns the amount of transaction' do
      expect(transaction.amount).to eq('100')
    end

    it 'returns the email used in transaction' do
      expect(transaction.email).to eq('christopher@andela.co')
    end
  end
end