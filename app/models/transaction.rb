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

  def balance
    @line['balance']['value']['amount']
  end

  def name
    get_field 'name'
  end

  def email
    get_field 'email'
  end

  def description
    begin
      h = ActiveSupport::JSON.decode(@line['description'])
      h['description']
    rescue
      'No description for this transaction'
    end
  end

  private
  def get_field field
    begin
      h = ActiveSupport::JSON.decode(@line['description'])
      h = ActiveSupport::JSON.decode(h['user'])
      h[field]
    rescue
      @line['description']
    end
  end
end