class BankFundManager < FundManager

  def initialize banker
    @client = SubledgerClient.instance
    @manager = FundManager.new
    @banker = banker
  end

  def user_transactions email
    response = @manager.transactions ENV['SYSTEM_ACC_CREDIT']
    response.select { |transaction| transaction if transaction.email == email }
    response.take(3)
  end

  def deposit amount
    description = {
        user: @banker.to_json,
        description: 'Deposit into system account'
    }
    @client.journal_entry(amount, description, ENV['SYSTEM_ACC_CREDIT'], ENV['SYSTEM_ACC'] ).code
  end

  def withdraw amount
    description = {
        user: @banker.to_json,
        description: 'Withdrawal from system account'
    }
    @client.journal_entry(amount, description,  ENV['SYSTEM_ACC'], ENV['SYSTEM_ACC_CREDIT'] ).code
  end
end