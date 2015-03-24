class CampaignDecorator < Draper::Decorator
  delegate_all

  def uppercase_title
    title.upcase
  end

  def embedded_youtube_url
    "https://www.youtube.com/embed/#{youtube_id}"
  end

  def youtube_id
    youtube_url.match(/^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/)[1]
  end

  def truncate_description
    description.truncate(140, separator: ' ')
  end

  def youtube_static_image
    "http://img.youtube.com/vi/#{youtube_id}/0.jpg"
  end
end