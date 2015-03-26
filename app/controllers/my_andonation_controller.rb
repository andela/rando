class MyAndonationController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc).limit(3)
    @campaigns_count = current_user.campaigns.count

    @transactions = JournalEntry.where(account_id: ENV["SYSTEM_ACC_CREDIT"]).order(created_at: :DESC).limit(3).decorate

    @distributions_history = current_user.journal_entry_records.where("journal_entries.account_id = ? AND journal_entries.transaction_type = ?",
                                                                ENV["SYSTEM_ACC_CREDIT"], 'debit').order(created_at: :DESC).decorate

    @distributions_three = current_user.journal_entry_records.where("journal_entries.account_id = ? AND journal_entries.transaction_type = ?",
                                                              ENV["SYSTEM_ACC_CREDIT"], 'debit').order(created_at: :DESC).limit(3).decorate

    # @withdrawals_history = current_user.journal_entry_records.where("journal_entries.account_id = ? AND journal_entries.transactions_type = ?",
    #                                                           ENV["SYSTEM_ACC_CREDIT"], 'debit').order(created_at: :DESC).decorate
    #
    # @withdrawals_three = current_user.journal_entry_records.where("journal_entries.account_id = ? AND journal_entries.transaction_type = ?",
    #                                                         ENV["SYSTEM_ACC_CREDIT"], 'debit').order(created_at: :DESC).limit(3).decorate

    @history = JournalEntry.where(account_id: current_user.account_id).order(created_at: :DESC).limit(3).decorate

    @balance = current_user.user_balance
  end

  def campaigns
    @campaigns = current_user.campaigns.order(created_at: :desc)
    @campaigns_count = current_user.campaigns.count
  end

  def my_transactions
    @history = JournalEntry.where(account_id: current_user.account_id).order(created_at: :DESC).decorate
  end

  def my_distributions
    @history = current_user.journal_entry_records.where("journal_entries.account_id = ? AND journal_entries.transaction_type = ?",
                                                  ENV["SYSTEM_ACC_CREDIT"], 'debit').order(created_at: :DESC).decorate
  end
end