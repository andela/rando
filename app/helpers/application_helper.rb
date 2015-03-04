module ApplicationHelper
  def formatted_date date, separator='-'
    date.strftime("%Y#{separator}%m#{separator}%d")
  end

  def capitalize_name name
    name.capitalize
  end
end