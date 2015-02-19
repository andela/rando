class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = current_user.campaigns.new(campaign_params)
    if @campaign.save
      redirect_to @campaign, notice: 'Campaign was successfully created.'
    else
      render :new
    end
  end

  def show
    @campaign = Campaign.find(params[:id]).try(:decorate)
  end

  private
    def campaign_params
      params.require(:campaign).permit(:title, :deadline, :amount, :description, :youtube_url)
    end
end