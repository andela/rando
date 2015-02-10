class CampaignsController < ApplicationController
  def new
    @campaign = Campaign.new #current_user.campaigns.new
  end
end