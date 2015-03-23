class MyAndonationController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc).limit(3)
    @campaigns_count = current_user.campaigns.count

    @transactions = current_user.transactions
    #from chiemeka
    @distributions_history = current_user.distributions
    @distributions_three = current_user.distributions.take(3)

    @history = current_user.transactions_history

    @balance = current_user.account_balance
  end

  def campaigns
    @campaigns = current_user.campaigns.order(created_at: :desc)
    @campaigns_count = current_user.campaigns.count
  end

  def my_transactions
    @history = current_user.all_transactions_history
  end
  #from chiemeka
  def my_distributions
    @history = current_user.distributions
  end
end