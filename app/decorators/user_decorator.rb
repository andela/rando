class UserDecorator < Draper::Decorator
  delegate_all

  def pretty_roles
    capitalized_roles.join(', ')
  end

  def balance
    client = SubledgerClient.instance
    client.balance(account_id)
  end

  private
  def sorted_roles
    roles.order(:name)
  end

  def capitalized_roles
    sorted_roles.decorate.map(&:capitalized_name)
  end
end