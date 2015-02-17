class Campaign < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :deadline, :amount, :user
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  validates :youtube_url, format: { with: /\A(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})(.*)\z/ },
            presence: true
  validates_numericality_of :amount, greater_than: 0

  validate :deadline_is_in_range, if: :deadline?

  delegate :name, to: :user, prefix: true

  private

  def deadline_is_in_range
    if deadline <= Date.today
      errors.add(:deadline, "can't be today or in the past")
    elsif deadline > Date.today + 30.days
      errors.add(:deadline, "can't be more than 30 days from today")
    end
  end
end

