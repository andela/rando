class CampaignsDecorator < Draper::CollectionDecorator
  delegate :total_pages, :current_page, :limit_value, :last_page?, :next_page
end