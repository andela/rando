class AddAccountIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :account_id, :string
  end
end
