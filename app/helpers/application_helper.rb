module ApplicationHelper
  def formatted_date date, separator='-'
    date.strftime("%Y#{separator}%m#{separator}%d")
  end
end