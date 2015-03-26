class CreateJournalEntries < ActiveRecord::Migration
  def change
    create_table :journal_entries do |t|
      t.string :transaction_type
      t.string :description
      t.integer :amount
      t.integer :balance
      t.string :account_id
      t.string :entry_id
      t.references :user, index: true
      t.references :recipient, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
