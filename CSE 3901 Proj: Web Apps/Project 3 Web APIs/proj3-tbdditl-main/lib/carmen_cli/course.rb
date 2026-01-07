# frozen_string_literal: true

# Class representing a Carmen course.
# It accepts the raw API hash (parsed JSON) and exposes a handful of read-only attributes.
# It is intended for student-accessible data only.
class Course
  # Public attributes we expose for student-accessible course data.
  attr_reader :id,
              :uuid,
              :name,
              :course_code,
              :original_name,
              :start_at,
              :end_at,
              :total_students,
              :time_zone

  # Construct a Course from a Canvas API response for a course object.
  def initialize(api_hash = {})
    @id = api_hash['id']
    @uuid = api_hash['uuid']
    @name = api_hash['name']
    @course_code = api_hash['course_code']
    @original_name = api_hash['original_name']
    @start_at = api_hash['start_at']
    @end_at = api_hash['end_at']
    @total_students = api_hash['total_students']
    @time_zone = api_hash['time_zone']
  end
end
