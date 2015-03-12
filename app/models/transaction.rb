class Transaction
  attr_accessor :line, :transaction_type, :posted_at, :amount, :email

  def self.create json_lines
    lines = json_lines
    lines.map { |line| Transaction.new(line) }
  end

  def initialize line
    @line = line
  end

  def transaction_type
    @line['value']['type'].capitalize
  end

  def posted_at
    @line["posted_at"].to_date.to_s
  end

  def amount
    @line["value"]["amount"]
  end

  def email
    begin
      h = ActiveSupport::JSON.decode(@line['description'])
      h['email']
    rescue
      @line['description']
    end
  end
end