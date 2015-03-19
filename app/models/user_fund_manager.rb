class UserFundManager < FundManager
#extract remaining methods user.rb
  def initialize user
    @client = SubledgerClient.instance
    @user = user
  end

  def allocate(user_ids, amount, reason)
    responses = []
    user_ids.each do |user_id|
      user = User.find(user_id)
      description = {
          user: user.to_json,
          description: reason
      }
      responses << @client.journal_entry(amount, description, user.account_id, ENV["SYSTEM_ACC_CREDIT"]).code
    end
    if responses.include?(201)
      201
    else
      202
    end
  end
end