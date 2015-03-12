class User < ActiveRecord::Base
  rolify
  has_many :campaigns
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]
  validates_presence_of :name
  validates :email, presence: true, uniqueness: true
  after_create :add_member_role

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
end
