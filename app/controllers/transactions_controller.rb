class TransactionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource except: :user_transactions
  before_action :load_client, only: [:index, :deposit, :withdraw]

  def index
    @transactions = FundManager.new.transactions ENV["SYSTEM_ACC_CREDIT"]
    @balance = FundManager.new.balance(ENV["SYSTEM_ACC_CREDIT"])
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
    response = @client.deposit(params[:amount])

    if response == 202
      flash[:notice] = 'Deposit Successful'
    else
      flash[:notice] = 'Transaction could not be made'
    end
    redirect_to transactions_path
  end

  def withdraw
    response = @client.withdraw(params[:amount])

    if response == 202
      flash[:notice] = 'Withdrawal Successful'
    else
      flash[:notice] = 'Withdrawal could not be made'
    end
    redirect_to transactions_path
  end

  def user_transactions
    authorize! :read, :distributors
    @user = User.find(params[:id])
    @transactions = @user.credit_transactions

    respond_to do |format|
      format.js
    end
  end

  private

  def load_client
    @client = BankFundManager.new current_user
  end
end