require 'singleton'
#extract parameters into hash

class SubledgerClient
  include Singleton
  include HTTParty

  base_uri "api.subledger.com:443/v2/orgs/#{ENV["ORG_ID"]}/books/#{ENV["BOOK_ID"]}"

  def initialize
    @auth = { username: ENV["KEY"], password: ENV["SECRET"] }
  end

  def balance account
    self.class.get("/accounts/#{account}/balance?at=#{time_now}", basic_auth: @auth)
  end

  def transactions account
    self.class.get("/accounts/#{account}/lines?action=before&effective_at=#{time_now}",
                              basic_auth: @auth)
  end
  
  def create_account(account_name)
    body = {
        description: account_name,
        reference: "http://www.andela.co/",
        normal_balance: "credit"
    }
    self.class.post("/accounts", body: body, basic_auth: @auth).body
  end

  def journal_entry(amount, description, credit_account, debit_account)
    self.class.post("/journal_entries/create_and_post", body: body(amount, description, credit_account , debit_account), basic_auth: @auth)
  end

  private

  def body(amount, description, credit_account, debit_account)
    {
        effective_at: time_now,
        description: description.to_json,
        reference: "http://www.andela.co/",
        lines: [{
                    account: credit_account,
                    description: description.to_json,
                    reference: "http://www.andela.co/",
                    value: {
                        type: 'credit',
                        amount:amount
                    }
                },
                {
                    account: debit_account,
                    description: description.to_json,
                    reference: "http://www.andela.co/",
                    value: {
                        type: 'debit',
                        amount:amount
                    }
                }]
    }
  end

  def time_now
    Time.zone.now.iso8601
  end
end