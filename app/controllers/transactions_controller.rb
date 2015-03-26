class TransactionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource except: :user_transactions
  before_action :load_client, only: [:index, :deposit, :withdraw]

  def index
    @transactions = JournalEntry.where(account_id: ENV["SYSTEM_ACC_CREDIT"]).order(created_at: :DESC).decorate
    account = Account.where(subledger_id: ENV["SYSTEM_ACC_CREDIT"]).first
    @balance = account.balance
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
    @transactions = JournalEntry.where("journal_entries.account_id = ? AND journal_entries.transaction_type = ?",
                                       @user.account_id, 'credit').order(created_at: :DESC).decorate

    respond_to do |format|
      format.js
    end
  end

  private

  def load_client
    @client = BankFundManager.new current_user
  end
end