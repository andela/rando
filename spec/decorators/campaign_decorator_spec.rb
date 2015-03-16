require 'rails_helper'

describe CampaignDecorator do
  before do
    allow_any_instance_of(SubledgerClient).to receive(:create_account).and_return("account_id")
  end

  describe '#embedded_youtube_url' do
    it 'creates an embedded youtube url' do
      campaign = create(:campaign, youtube_url: 'https://www.youtube.com/watch?v=7WJk-z5AmXk').decorate
      expect(campaign.embedded_youtube_url).to eq('https://www.youtube.com/embed/7WJk-z5AmXk')
    end
  end

  describe '#youtube_id' do
    it 'extracts youtube id from youtube url' do
      campaign = create(:campaign, youtube_url: 'http://www.youtu.be/s3wXkv1VW54&feature=fvst').decorate
      expect(campaign.youtube_id).to eq('s3wXkv1VW54')
    end
  end

  describe '#uppercase_title' do
    it 'converts title to uppercase' do
      campaign = create(:campaign, title: 'lower case title').decorate
      expect(campaign.uppercase_title).to eq('LOWER CASE TITLE')
    end
  end

  describe '#truncate_description' do
    it 'truncates description in homepage' do
      campaign = create(:campaign, description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eorum enim est haec querela, qui sibi cari sunt seseque diligunt. Ut proverbia non nulla veriora sint quam vestra dogmata.').decorate
      expect(campaign.truncate_description).to eq('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eorum enim est haec querela, qui sibi cari sunt seseque diligunt. Ut proverbia...')
    end
  end
end