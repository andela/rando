require 'rails_helper'

describe CampaignDecorator do
  describe '#formatted_deadline' do
    it 'formats deadline' do
      campaign = create(:campaign, deadline: Date.tomorrow).decorate
      expect(campaign.formatted_deadline).to eq(Date.tomorrow.strftime('%Y/%m/%d'))
    end
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
end