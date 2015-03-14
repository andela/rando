class AddAccountIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_id, :string
  end
end
