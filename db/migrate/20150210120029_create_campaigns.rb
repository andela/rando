class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.date :deadline
      t.decimal :amount
      t.text :description
      t.string :youtube_url
      t.references :user

      t.timestamps null: false
    end
  end
end
