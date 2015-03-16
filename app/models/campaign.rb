class Campaign < ActiveRecord::Base
  DISPLAY_COUNT = 20
  belongs_to :user
  validates_presence_of :deadline, :amount, :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  validates :youtube_url, format: { with: /\A(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})(.*)\z/ },
            presence: true
  validates_numericality_of :amount, greater_than: 0
  validate :deadline_is_in_range, if: :deadline?

  after_create :create_account

  delegate :name, to: :user, prefix: true

  private

  def deadline_is_in_range
    if new_record?
      if deadline <= Date.today
        errors.add(:deadline, "can't be today or in the past")
      elsif deadline > Date.today + 30.days
        errors.add(:deadline, "can't be more than 30 days from today")
      end
    elsif deadline > created_at + 30.days
      errors.add(:deadline, "can't be more than 30 days from created date")
    end
  end

  def create_account
    client = SubledgerClient.new
    self.account_id = client.create_account(self.to_json)
    self.save
  end
end

