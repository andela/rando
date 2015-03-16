class SubledgerClient
  include HTTParty

  base_uri "api.subledger.com:443/v2/orgs/#{ENV["ORG_ID"]}/books/#{ENV["BOOK_ID"]}"
  
  def create_account(account_name)
    body = {
        description: account_name,
        reference: "http://www.andela.co/",
        normal_balance: "credit"
    }
    response = self.class.post("/accounts", body: body, basic_auth: @auth).body
    decode(response)["active_account"]["id"]
  end

  def initialize
    @auth = { username: ENV["KEY"], password: ENV["SECRET"] }
  end

  def transactions
    response = self.class.get("/accounts/#{ENV["SYSTEM_ACC_CREDIT"]}/lines?action=before&effective_at=#{time_now}",
                              basic_auth: @auth)
    Transaction.create(decode(response.body)["posted_lines"])
  end

  def user_transactions email
    response = transactions
    select_three(response.select { |transaction| transaction if transaction.email == email })
  end

  def balance account
    response = self.class.get("/accounts/#{account}/balance?at=#{time_now}", basic_auth: @auth)
    decode(response.body)["balance"]["value"]["amount"]
  end

  def deposit (amount, current_user)
    description = {
        user: current_user.to_json,
        description: "Deposit into system accout"
    }
    response = execute_transaction(amount, description, ENV["SYSTEM_ACC_CREDIT"], ENV["SYSTEM_ACC"])
    response.code
  end

  def withdraw (amount, current_user)
    description = {
        user: current_user.to_json,
        description: "Withdrawal from system accout"
    }

    response = execute_transaction(amount, description, ENV["SYSTEM_ACC"], ENV["SYSTEM_ACC_CREDIT"])
    response.code
  end

  def allocate(user_ids, amount, current_user)
    responses = []
    user_ids.each do |user_id|
      user = User.find(user_id)
      description = {
          user: current_user.to_json,
          description: "Allocate money to #{user.name}"
      }
      responses << execute_transaction(amount, description, user.account_id, ENV["SYSTEM_ACC_CREDIT"]).code
    end
    if responses.include?(201)
      201
    else
      202
    end
  end

  private

  def decode body
    ActiveSupport::JSON.decode(body)
  end

  def body(amount, current_user, credit_account, debit_account)

    {
        effective_at: time_now,
        description: current_user.to_json,
        reference: "http://www.andela.co/",
        lines: [{
                    account: credit_account,
                    description: current_user.to_json,
                    reference: "http://www.andela.co/",
                    value: {
                        type: 'credit',
                        amount:amount
                    }
                },
                {
                    account: debit_account,
                    description: current_user.to_json,
                    reference: "http://www.andela.co/",
                    value: {
                        type: 'debit',
                        amount:amount
                    }
                }]
    }
  end

  def execute_transaction(amount, current_user,credit_account, debit_account)
    self.class.post("/journal_entries/create_and_post", body: body(amount, current_user, credit_account , debit_account), basic_auth: @auth)
  end

  def time_now
    Time.zone.now.iso8601
  end

  def select_three transactions
    $i = 0
    filtered_transaction = []
    while $i < transactions.length  do
      filtered_transaction.push(transactions[$i])
      $i +=1
      break if $i == 3
    end
    filtered_transaction
  end
end