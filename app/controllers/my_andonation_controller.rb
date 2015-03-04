class MyAndonationController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc).limit(3)
    @campaigns_count = current_user.campaigns.count
  end

  def campaigns
    @campaigns = current_user.campaigns.order(created_at: :desc)
    @campaigns_count = current_user.campaigns.count
  end
end