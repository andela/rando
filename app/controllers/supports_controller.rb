class SupportsController < ApplicationController
before_action :authenticate_user!
before_action :set_campaign
before_action :check_balance, only: :create

  def new
    @needed = @campaign.needed - @campaign.raised

    client = FundManager.new
    @user_balance = client.balance current_user.account_id

    respond_to do |format|
      format.js
    end
  end

  def create
    @raised_value = params[:raised].to_i
    @reason = params[:reason]

    @campaign.update_attribute(:raised, @campaign.raised + @raised_value)

    @campaign_account = @campaign.account_id
    @user_account_id = current_user.account_id

    client = UserFundManager.new current_user
    client.allocate_campaign current_user.id, @user_account_id, @campaign_account, @raised_value, @reason

    redirect_to @campaign, notice: 'You have supported this campaign'
  end

  def check_balance
    @user_account_id = current_user.account_id
    client = FundManager.new
    @user_balance = client.balance @user_account_id
    @raised_value = params[:raised].to_i
    if @raised_value > @user_balance.to_i
      redirect_to @campaign, alert: 'You cannot support more than you have in your account'
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end