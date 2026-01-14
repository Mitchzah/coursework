# == Schema Information
#
# Table name: expenses
#
#  id            :integer          not null, primary key
#  amount        :decimal(10, 2)
#  category      :string
#  description   :string
#  due_date      :date
#  incurred_date :date
#  raw_currency  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  payer_id      :integer          not null
#  trip_id       :integer          not null
#
# Indexes
#
#  index_expenses_on_payer_id  (payer_id)
#  index_expenses_on_trip_id   (trip_id)
#
# Foreign Keys
#
#  payer_id  (payer_id => users.id)
#  trip_id   (trip_id => trips.id)
#
require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
