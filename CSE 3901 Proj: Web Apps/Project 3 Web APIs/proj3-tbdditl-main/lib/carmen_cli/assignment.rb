# frozen_string_literal: true

# Class representing a Carmen assignment.
# It accepts the raw API hash (parsed JSON) and exposes a handful of read-only attributes.
# It is intended for student-accessible data only.
class Assignment
  # Public attributes we expose for student-accessible assignment data.
  attr_reader :id,
              :name,
              :description,
              :created_at,
              :due_at,
              :course_id

  # Construct an Assignment from a Canvas API response for an assignment object.
  def initialize(api_hash = {})
    @id = api_hash['id']
    @name = api_hash['name']
    @description = api_hash['description']
    @created_at = api_hash['created_at']
    @due_at = api_hash['due_at']
    @course_id = api_hash['course_id']
  end
end
