require 'rails_helper'

describe BankFundManager, type: :model do
  let(:user) { create(:user) }
  let(:manager) { BankFundManager.new(user) }
  describe '#user_transactions' do
    it 'it returns an array of transactions for a specific user' do
      transaction = Transaction.new(ActiveSupport::JSON.decode(expected_transactions)[1])
      allow_any_instance_of(FundManager).to receive(:transactions).and_return([transaction])

      expect(manager.user_transactions('franklin.ugwu@andela.co')[0]).to eq(transaction)
    end
  end

  describe '#deposit' do
    it 'returns status code of 202 for successful deposit' do
      response = double('response', code: '202')

      allow_any_instance_of(SubledgerClient).to receive(:journal_entry).and_return(response)
      expect(manager.deposit('200')).to eq('202')
    end
  end

  describe '#withdraw' do
    it 'returns status code of 202 for successful deposit' do
      user = create(:user)
      response = double('response', code: '202')

      allow_any_instance_of(SubledgerClient).to receive(:journal_entry).and_return(response)
      expect(manager.withdraw('200')).to eq('202')
    end
  end
end