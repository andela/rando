class JournalEntryDecorator < Draper::Decorator
  delegate_all
  def formatted_date
    created_at.to_date
  end
end