# frozen_string_literal: true

# Represents a student-accessible grade returned from the Carmen API.
# Provides read-only access to assignment ID, score, grade, and submission timestamp,
# along with a writable assignment name for convenience.
class Grade
  attr_reader :assignment_id,
              :score,
              :grade,
              :submitted_at

  attr_accessor :assignment_name

  def initialize(api_hash = {})
    @assignment_id = api_hash['assignment_id']
    @assignment_name = api_hash['name']
    @score = api_hash['score']
    @grade = api_hash['grade']
    @submitted_at = api_hash['submitted_at']
  end
end
