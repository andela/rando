class SubledgerClient
  include HTTParty

  base_uri "api.subledger.com:443/v2/orgs/#{ENV["ORG_ID"]}/books/#{ENV["BOOK_ID"]}"


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

  def balance
    response = self.class.get("/accounts/#{ENV["SYSTEM_ACC_CREDIT"]}/balance?at=#{time_now}", basic_auth: @auth)
    decode(response.body)["balance"]["value"]["amount"]
  end

  def deposit (amount, current_user)
    response = execute_transaction(amount, current_user, 'credit', 'debit')
    response.code
  end

  def withdraw (amount, current_user)
    response = execute_transaction(amount, current_user, 'debit', 'credit')
    response.code
  end

  private

  def decode body
    ActiveSupport::JSON.decode(body)
  end

  def body(amount, current_user, type1, type2)

    {
        effective_at: time_now,
        description: current_user.email,
        reference: "http://www.andela.co/",
        lines: [{
                    account: ENV["SYSTEM_ACC_CREDIT"],
                    description: current_user.email,
                    reference: "http://www.andela.co/",
                    value: {
                        type: type1,
                        amount:amount
                    }
                },
                {
                    account: ENV["SYSTEM_ACC"],
                    description: current_user.email,
                    reference: "http://www.andela.co/",
                    value: {
                        type: type2,
                        amount:amount
                    }
                }]
    }
  end

  def execute_transaction(amount, current_user, type1, type2)
    self.class.post("/journal_entries/create_and_post", body: body(amount, current_user, type1, type2), basic_auth: @auth)
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