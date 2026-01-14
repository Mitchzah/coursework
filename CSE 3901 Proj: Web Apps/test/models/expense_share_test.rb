# == Schema Information
#
# Table name: expense_shares
#
#  id          :integer          not null, primary key
#  amount_owed :decimal(10, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  debtor_id   :integer          not null
#  expense_id  :integer          not null
#
# Indexes
#
#  index_expense_shares_on_debtor_id   (debtor_id)
#  index_expense_shares_on_expense_id  (expense_id)
#
# Foreign Keys
#
#  debtor_id   (debtor_id => users.id)
#  expense_id  (expense_id => expenses.id)
#
require "test_helper"

class ExpenseShareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
