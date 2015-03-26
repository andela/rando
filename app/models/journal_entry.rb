class JournalEntry < ActiveRecord::Base
  belongs_to :recipient, polymorphic: true
  belongs_to :user
end
