require 'rails_helper'

describe Campaign, type: :model do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:deadline) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:youtube_url) }
end
