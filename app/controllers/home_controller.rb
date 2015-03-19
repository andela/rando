class HomeController < ApplicationController
  def index
    @current_campaigns = Campaign.current.order(created_at: :desc).limit(3).decorate
    @current_campaigns_count = Campaign.current.count
    @campaigns_count = Campaign.count
  end
end