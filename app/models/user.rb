class User < ActiveRecord::Base
  rolify
  has_many :campaigns
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]
  validates_presence_of :name
  validates :email, presence: true, uniqueness: true
  after_create :add_member_role, :create_account
  scope :unique_roles, ->(users_ids) { where(id: users_ids).where.not(roles: {name: 'member'}).joins(:roles).uniq.order('roles.name').pluck('roles.name') }

  def self.find_for_google_oauth2(google_response)
    return nil unless google_response_valid?(google_response)
    data = google_response.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(email: data['email'], name: data['name'], first_name: data['first_name'], last_name: data['last_name'])
    end
    user
  end

  def self.google_response_valid?(google_response)
    google_response.try(:info).present?
  end

  def add_member_role
    self.add_role :member
  end

  def as_json(opts={})
    {id: self.id, email: self.email, name: self.name}
  end

  def self.update_roles(users_ids, role_names, admin)
    users = find(users_ids[0].split(' '))
    users.each do |user|
      user.update_roles(role_names, admin)
    end
  end

  def update_roles(role_names, admin)
    role_names ||= []
    Role::ROLE_NAMES.each do |role|
      if role_names.include?(role)
        self.add_role(role) unless self.has_role?(role)
      else
        self.remove_role(role) unless self == admin && role == 'admin'
      end
    end
  end

  def create_account
    manager = FundManager.new
    self.account_id = manager.create_account(self.to_json)
    self.save
  end

  def transactions
    manager = BankFundManager.new self
    manager.user_transactions(email)
  end

  def transactions_history
    manager = FundManager.new
    manager.transactions(account_id).take(3)
  end

  def all_transactions_history
    client = FundManager.new
    client.transactions(account_id)
  end

  def transaction_count
    all_transactions_history.count
  end

  def account_balance
    client = FundManager.new
    client.balance(account_id)
  end

  def credit_transactions
    all_transactions_history.select { |transaction| transaction.transaction_type == 'Credit' }
  end
end
