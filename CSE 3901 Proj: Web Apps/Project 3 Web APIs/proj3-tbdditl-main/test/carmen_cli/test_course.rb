# frozen_string_literal: true

# Unit tests for the Course class.
# Ensures that Course objects are correctly initialized from API hash data,
# including handling of minimal, full, empty, partial, nil, and extra fields.

require 'minitest/autorun'
require './lib/carmen_cli'

class TestCourse < Minitest::Test
  def test_course_creation_with_minimal_data
    course_data = {
      'id' => 101,
      'name' => 'Introduction to Testing',
      'course_code' => 'TEST1'
    }

    course = Course.new(course_data)
    assert_equal course_data['id'], course.id
    assert_equal course_data['name'], course.name
    assert_equal course_data['course_code'], course.course_code
    assert_nil course.uuid
    assert_nil course.original_name
    assert_nil course.start_at
    assert_nil course.end_at
    assert_nil course.total_students
    assert_nil course.time_zone
  end

  def test_course_creation_with_full_data
    course_data = {
      'id' => 102,
      'uuid' => 'abc-123-def-456',
      'name' => 'Advanced Testing',
      'course_code' => 'TEST2',
      'original_name' => 'Advanced Testing Methods',
      'start_at' => '2025-08-26T08:00:00Z',
      'end_at' => '2025-12-18T17:00:00Z',
      'total_students' => 45,
      'time_zone' => 'America/New_York'
    }

    course = Course.new(course_data)
    assert_equal course_data['id'], course.id
    assert_equal course_data['uuid'], course.uuid
    assert_equal course_data['name'], course.name
    assert_equal course_data['course_code'], course.course_code
    assert_equal course_data['original_name'], course.original_name
    assert_equal course_data['start_at'], course.start_at
    assert_equal course_data['end_at'], course.end_at
    assert_equal course_data['total_students'], course.total_students
    assert_equal course_data['time_zone'], course.time_zone
  end

  def test_course_creation_with_empty_data
    course_data = {}
    course = Course.new(course_data)
    assert_nil course.id
    assert_nil course.uuid
    assert_nil course.name
    assert_nil course.course_code
    assert_nil course.original_name
    assert_nil course.start_at
    assert_nil course.end_at
    assert_nil course.total_students
    assert_nil course.time_zone
  end

  def test_course_creation_with_partial_data
    course_data = {
      'id' => 103,
      'name' => 'Partial Data Course',
      'start_at' => '2025-08-26T08:00:00Z'
      # Other fields like 'course_code', 'uuid', 'end_at', etc. are missing
    }

    course = Course.new(course_data)
    assert_equal course_data['id'], course.id
    assert_equal course_data['name'], course.name
    assert_equal course_data['start_at'], course.start_at
    assert_nil course.uuid
    assert_nil course.course_code
    assert_nil course.original_name
    assert_nil course.end_at
    assert_nil course.total_students
    assert_nil course.time_zone
  end

  def test_course_creation_with_nil_fields
    course_data = {
      'id' => 104,
      'name' => nil,
      'course_code' => 'TEST4',
      'uuid' => nil,
      'total_students' => 25,
      'time_zone' => nil
    }

    course = Course.new(course_data)
    assert_equal course_data['id'], course.id
    assert_nil course.name
    assert_equal course_data['course_code'], course.course_code
    assert_nil course.uuid
    assert_equal course_data['total_students'], course.total_students
    assert_nil course.time_zone
    assert_nil course.original_name
    assert_nil course.start_at
    assert_nil course.end_at
  end

  def test_course_creation_with_extra_fields
    course_data = {
      'id' => 105,
      'name' => 'Extra Fields Course',
      'course_code' => 'TEST5',
      'start_at' => '2026-01-15T08:00:00Z',
      'end_at' => '2026-05-15T17:00:00Z',
      'extra_field1' => 'Extra Value 1',
      'extra_field2' => 'Extra Value 2',
      'another_field' => 'Should be ignored'
    }

    course = Course.new(course_data)
    assert_equal course_data['id'], course.id
    assert_equal course_data['name'], course.name
    assert_equal course_data['course_code'], course.course_code
    assert_equal course_data['start_at'], course.start_at
    assert_equal course_data['end_at'], course.end_at
    # Extra fields should be ignored by the Course class
    refute_respond_to course, :extra_field1
    refute_respond_to course, :extra_field2
    refute_respond_to course, :another_field
  end

  def test_course_creation_with_no_arguments
    course = Course.new
    assert_nil course.id
    assert_nil course.uuid
    assert_nil course.name
    assert_nil course.course_code
    assert_nil course.original_name
    assert_nil course.start_at
    assert_nil course.end_at
    assert_nil course.total_students
    assert_nil course.time_zone
  end
end
