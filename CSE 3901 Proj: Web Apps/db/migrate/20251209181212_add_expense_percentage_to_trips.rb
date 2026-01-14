class AddExpensePercentageToTrips < ActiveRecord::Migration[7.2]
  def change
    add_column :trips, :creator_expense_percentage, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
