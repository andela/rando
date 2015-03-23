class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :funded]

  def index
    @campaigns = Campaign.ordered_page(params[:page]).current.decorate
  end

  def funded
    @campaigns = Campaign.ordered_page(params[:page]).funded.decorate
  end

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

    client = FundManager.new
    @transactions = client.transactions @campaign.account_id
  end

  def edit
    @campaign = current_user.campaigns.find(params[:id].to_i)
  end

  def update
    @campaign = current_user.campaigns.find(params[:id])

    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: 'Campaign was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @campaign = current_user.campaigns.find(params[:id].to_i)

    @campaign.destroy
    redirect_to my_andonation_path, notice: 'Campaign was successfully deleted.'
  end

  private
    def campaign_params
      params.require(:campaign).permit(:title, :deadline, :needed, :description, :youtube_url)
    end
end