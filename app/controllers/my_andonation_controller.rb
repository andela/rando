class MyAndonationController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc).limit(3)
    @campaigns_count = current_user.campaigns.count
    client = SubledgerClient.new
    @transactions = client.user_transactions(current_user.email)
  end

  def campaigns
    @campaigns = current_user.campaigns.order(created_at: :desc)
    @campaigns_count = current_user.campaigns.count
  end
end