class MyCampaignsController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_campaigns = current_user.campaigns.order(created_at: :desc)
    @my_campaigns_count = current_user.campaigns.count
  end
end