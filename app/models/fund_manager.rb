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

  private

  def decode body
    ActiveSupport::JSON.decode(body)
  end
end