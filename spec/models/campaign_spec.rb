require 'rails_helper'

describe Campaign, type: :model do

  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
  end

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:deadline) }
  it { is_expected.to validate_presence_of(:needed) }
  it { is_expected.to validate_numericality_of(:needed).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:youtube_url) }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:description).is_at_least(20) }
  it { is_expected.not_to allow_value('www.google.com/video', 'youtube.com/watch').for(:youtube_url) }
  it { is_expected.to allow_value('https://www.youtube.com/watch?v=jGnoIDJFrZI').for(:youtube_url) }

  describe 'validations' do
    context 'deadline is defined' do
      before do
        @campaign = build(:campaign, deadline: deadline)
        @campaign.save
      end

      context 'deadline is yesterday' do
        let(:deadline) { Date.yesterday }

        it 'object is invalid' do
          expect(@campaign).not_to be_valid
        end

        it 'returns error message' do
          expect(@campaign.errors.full_messages).to include("Deadline can't be today or in the past")
        end
      end

      context 'deadline is today' do
        let(:deadline) { Date.today }

        it 'object is invalid' do
          expect(@campaign).not_to be_valid
        end

        it 'returns error message' do
          expect(@campaign.errors.full_messages).to include("Deadline can't be today or in the past")
        end
      end

      context 'deadline is tomorrow' do
        let(:deadline) { Date.tomorrow + 1.day }

        it 'object is valid' do
          expect(@campaign).to be_valid
        end
      end

      context 'deadline is more than 30 days' do
        let(:deadline) { Date.today + 31.days }

        it 'object is invalid' do
          expect(@campaign).not_to be_valid
        end

        it 'returns error message' do
          expect(@campaign.errors.full_messages).to include("Deadline can't be more than 30 days from today")
        end
      end
    end

    context 'deadline is nil' do
      before do
        @campaign = build(:campaign, deadline: nil)
      end

      it 'does not throw exception' do
        expect { @campaign.save }.not_to raise_error
      end
    end

    context 'deadline when editing campaign' do
      before do
        @campaign = create(:campaign, created_at: Date.today - 20.days)
        @campaign.update_attributes(deadline: Date.today + 15.days)
      end

      context 'deadline is more than 30 days form creation' do
        it 'object is invalid' do
          expect(@campaign).not_to be_valid
        end

        it 'returns error message' do
          expect(@campaign.reload.errors.full_messages).to include("Deadline can't be more than 30 days from created date")
        end
      end

      context 'deadline is today' do
        before do
          @campaign.update_attributes(deadline: Date.today)
        end

        it 'object should be valid' do
          expect(@campaign).to be_valid
        end
      end
    end
  end

  describe '#create_campaign_account' do
    let(:campaign) { create (:campaign) }

    it 'campaign has an account' do
      allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
      expect(campaign.account_id).to eq("account_id")
    end
  end

  describe '.current' do
    let(:non_expired_campaign) { create(:campaign, deadline: Date.today + 1.day, raised: 250) }
    let(:non_funded_campaign) { create(:campaign, needed: 200, raised: 100) }
    let(:expired_campaign) { create(:campaign) }
    let(:funded_campaign) { create(:campaign, needed: 200, raised: 200) }

    subject { Campaign.current }

    it { is_expected.to include(non_expired_campaign) }
    it { is_expected.to include(non_funded_campaign) }
    it { expired_campaign.update_attribute(:deadline, Date.yesterday)
         is_expected.to_not include(expired_campaign) }
    it { is_expected.to_not include(funded_campaign) }
  end
end
