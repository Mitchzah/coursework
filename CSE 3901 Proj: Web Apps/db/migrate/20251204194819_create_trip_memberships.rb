class CreateTripMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :trip_memberships do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :attendee, null: false, foreign_key: { to_table: :users }
      t.index [:trip_id, :attendee_id], unique: true

      t.timestamps
    end
  end
end
