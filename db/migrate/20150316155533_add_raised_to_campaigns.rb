class AddRaisedToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :raised, :integer, limit: 8, default: 0
    rename_column :campaigns, :amount, :needed
  end
end
