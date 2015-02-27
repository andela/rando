class ChangeAmountFormatInCampaigns < ActiveRecord::Migration
  def up
    change_column :campaigns, :amount, :integer, limit: 8
  end
end