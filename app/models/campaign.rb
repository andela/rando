class Campaign < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :deadline, :amount, :description, :youtube_url, :user
  delegate :name, to: :user, prefix: true
end
