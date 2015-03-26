require 'rails_helper'

describe UserFundManager, type: :model do
  before do
    allow_any_instance_of(FundManager).to receive(:balance).and_return(200)
    allow_any_instance_of(FundManager).to receive(:update_system_balance).and_return(200)
  end
  describe '#allocate' do
    it 'return status 202 code' do
      user = create(:user)
      manager = UserFundManager.new user
      res = double("response", body: '{
                          "posting_journal_entry": {
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

  describe '#allocate_campaign' do
    it 'returns status code 202' do
      user = create(:user)
      campaign = create(:campaign)

      client = UserFundManager.new user
      res = double("response", body: '{
                            "posting_journal_entry": {
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

      expect(client.allocate_campaign(user.id, user.account_id, campaign.account_id, 40, 'Its a nice campaign')).to eq(202)
    end
  end
end