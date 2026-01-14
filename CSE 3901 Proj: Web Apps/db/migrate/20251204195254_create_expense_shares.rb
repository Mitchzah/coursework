class CreateExpenseShares < ActiveRecord::Migration[7.2]
  def change
    create_table :expense_shares do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :debtor, null: false, foreign_key: { to_table: :users }
      t.decimal :amount_owed, precision: 10, scale: 2

      t.timestamps
    end
  end
end
