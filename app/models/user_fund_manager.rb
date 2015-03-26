class UserFundManager < FundManager
#extract remaining methods user.rb
  def initialize user
    @client = SubledgerClient.instance
    @manager = FundManager.new
    @user = user
  end

  def allocate(user_ids, amount, reason)
    responses = []
    user_ids.each do |user_id|
      recipient = User.find(user_id)
      description = {
          user: @user.to_json,
          description: reason,
          recipient: recipient.name
      }
      response = @client.journal_entry(amount, description, recipient.account_id, ENV["SYSTEM_ACC_CREDIT"])

      if response.code.eql?(202)
        entry_id = decode(response.body)['posting_journal_entry']['id']
        balance = @manager.balance(recipient.account_id)
        recipient.update_attributes(user_balance: balance)

        options = {  description: reason,
                     transaction_type: 'credit',
                     amount: amount,
                     balance: balance,
                     account_id: recipient.account_id,
                     entry_id: entry_id,
                     recipient: recipient,
                     recipient_id: recipient.id,
                     recipient_type: 'User'
        }

        @manager.create_journal_entry @user, options

        options = {  description: reason,
                     transaction_type: 'debit',
                     amount: amount,
                     balance: balance,
                     account_id: ENV["SYSTEM_ACC_CREDIT"],
                     entry_id: entry_id,
                     recipient: recipient,
                     recipient_id: recipient.id,
                     recipient_type: 'User'
        }

        @manager.create_journal_entry @user, options
      end
      responses << response.code
    end
    if responses.include?(201)
      201
    else
      202
    end
  end

  def allocate_campaign(user_id, user_acct, campaign_acct, amount, reason)
    responses = []
    user = User.find(user_id)
    campaign = Campaign.where(account_id: campaign_acct).first
    description = {
        user: user.to_json,
        description: reason
    }

    response = @client.journal_entry(amount, description, campaign_acct, user_acct)

    if response.code.eql?(202)
      entry_id = decode(response.body)['posting_journal_entry']['id']
      balance = @manager.balance(user.account_id)
      
      user.update_attributes(user_balance: balance)

      options = {  description: reason,
                   transaction_type: 'debit',
                   amount: amount,
                   balance: balance,
                   account_id: user.account_id,
                   entry_id: entry_id,
                   recipient: campaign,
                   recipient_id: campaign.id,
                   recipient_type: 'Campaign'
      }

      @manager.create_journal_entry user, options
    end

    responses << response.code
    if responses.include?(201)
      201
    else
      202
    end
  end
end