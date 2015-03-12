class TransactionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :load_client, only: [:index, :deposit, :withdraw]

  def index
    @transactions = @client.transactions
    @balance = @client.balance
  end

  def new_deposit
    respond_to do |format|
      format.js
    end
  end

  def new_withdrawal
    respond_to do |format|
      format.js
    end
  end

  def deposit
    response = @client.deposit(params[:amount], current_user)

    if response == 202
      flash[:notice] = 'Deposit Successful'
    else
      flash[:notice] = 'Transaction could not be made'
    end
    redirect_to transactions_path
  end

  def withdraw
    response = @client.withdraw(params[:amount], current_user)

    if response == 202
      flash[:notice] = 'Withdrawal Successful'
    else
      flash[:notice] = 'Withdrawal could not be made'
    end
    redirect_to transactions_path
  end

  private

  def load_client
    @client = SubledgerClient.new
  end
end