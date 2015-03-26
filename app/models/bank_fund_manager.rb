class BankFundManager < FundManager

  def initialize banker
    @client = SubledgerClient.instance
    @manager = FundManager.new
    @banker = banker
  end

  def deposit amount
    description = {
        user: @banker.to_json,
        description: 'Deposit into system account'
    }
    response = @client.journal_entry(amount, description, ENV['SYSTEM_ACC_CREDIT'], ENV['SYSTEM_ACC'] )
    update_system_account response, 'Deposit into system account', 'credit', amount
    response.code
  end

  def withdraw amount
    description = {
        user: @banker.to_json,
        description: 'Withdrawal from system account'
    }
    response = @client.journal_entry(amount, description,  ENV['SYSTEM_ACC'], ENV['SYSTEM_ACC_CREDIT'] )
    update_system_account response, 'Withdrawal from system account', 'debit', amount
    response.code
  end

  private

  def decode body
    ActiveSupport::JSON.decode(body)
  end

  def update_system_account response, description, type, amount
    if response.code.eql?(202)
      entry_id = decode(response.body)['posting_journal_entry']['id']
      balance = @manager.update_system_balance


      options = {  description: description,
                   transaction_type: type,
                   amount: amount,
                   balance: balance,
                   account_id: ENV["SYSTEM_ACC_CREDIT"],
                   entry_id: entry_id
      }

      @manager.create_journal_entry @banker, options
    end
  end
end