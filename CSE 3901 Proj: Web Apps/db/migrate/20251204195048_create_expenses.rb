class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :payer, null: false, foreign_key: { to_table: :users }
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.string :category
      t.date :incurred_date
      t.string :raw_currency

      t.timestamps
    end
  end
end
