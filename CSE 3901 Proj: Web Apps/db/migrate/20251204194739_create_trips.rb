class CreateTrips < ActiveRecord::Migration[7.2]
  def change
    create_table :trips do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :base_currency
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
