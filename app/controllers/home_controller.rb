class HomeController < ApplicationController
  def index
    @current_campaigns = Campaign.current.desc_order.limit(3).decorate
    @funded_campaigns = Campaign.funded.desc_order.limit(3).decorate
    @current_campaigns_count = Campaign.current.count
    @funded_campaigns_count = Campaign.funded.count
  end
end