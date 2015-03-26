class AddUserBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_balance, :integer
  end
end
