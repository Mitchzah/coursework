# == Schema Information
#
# Table name: trip_memberships
#
#  id                 :integer          not null, primary key
#  expense_percentage :decimal(5, 2)    default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attendee_id        :integer          not null
#  trip_id            :integer          not null
#
# Indexes
#
#  index_trip_memberships_on_attendee_id              (attendee_id)
#  index_trip_memberships_on_trip_id                  (trip_id)
#  index_trip_memberships_on_trip_id_and_attendee_id  (trip_id,attendee_id) UNIQUE
#
# Foreign Keys
#
#  attendee_id  (attendee_id => users.id)
#  trip_id      (trip_id => trips.id)
#
require "test_helper"

class TripMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
