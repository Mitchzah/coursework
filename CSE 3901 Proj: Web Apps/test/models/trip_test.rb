# == Schema Information
#
# Table name: trips
#
#  id                         :integer          not null, primary key
#  base_currency              :string
#  creator_expense_percentage :decimal(5, 2)    default(0.0)
#  description                :text
#  end_date                   :date
#  start_date                 :date
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  creator_id                 :integer          not null
#
# Indexes
#
#  index_trips_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  creator_id  (creator_id => users.id)
#
require "test_helper"

class TripTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
