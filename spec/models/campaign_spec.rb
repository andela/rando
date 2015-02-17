require 'rails_helper'

describe Campaign, type: :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:deadline) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:youtube_url) }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:description).is_at_least(20) }
  it { is_expected.not_to allow_value('www.google.com/video', 'youtube.com/watch').for(:youtube_url) }
  it { is_expected.to allow_value('https://www.youtube.com/watch?v=jGnoIDJFrZI').for(:youtube_url)}

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
        let(:deadline) { Date.tomorrow }

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
  end
end
