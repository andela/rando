require 'rails_helper'

describe UserFundManager, type: :model do
  describe '#allocate' do
    it 'return status 202 code' do
      user = create(:user)
      manager = UserFundManager.new user
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

      expect(manager.allocate([user.id], 12, 'he is a good person')).to eq(202)
    end
  end
end