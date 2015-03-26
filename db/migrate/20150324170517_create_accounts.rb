class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subledger_id
      t.integer :balance
      t.references :user

      t.timestamps null: false
    end
  end
end
