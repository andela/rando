class FundManager

  def initialize
    @client = SubledgerClient.instance
  end

  def balance account
    decode(@client.balance(account).body)["balance"]["value"]["amount"]
  end

  def transactions account
    Transaction.create(decode(@client.transactions(account).body)["posted_lines"])
  end

  def create_account(account_name)
    decode(@client.create_account(account_name))["active_account"]["id"]
  end

  def create_journal_entry user, options
    user.journal_entry_records.create(options)
  end

  def update_system_balance
    account = Account.where(subledger_id: ENV["SYSTEM_ACC_CREDIT"]).first
    balance = balance(ENV["SYSTEM_ACC_CREDIT"])
    account.update_attributes(balance: balance)
    balance
  end

  private

  def decode body
    ActiveSupport::JSON.decode(body)
  end
end