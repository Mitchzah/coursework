# frozen_string_literal: true

# Unit tests for the Grade class.
# Ensures that Grade objects are correctly initialized from API hash data,
# including handling of regular data, missing fields, empty strings,
# assignment name mutation, and raw data type preservation.

require 'minitest/autorun'
require './lib/carmen_cli'

class TestGrade < Minitest::Test
  def test_initialize_with_regular_data
    grade_data = {
      'assignment_id' => 42,
      'name' => 'Project 3',
      'score' => 95.5,
      'grade' => 'A',
      'submitted_at' => '2025-10-12T12:34:56Z'
    }
    g = Grade.new(grade_data)
    assert_equal 42, g.assignment_id
    assert_equal 'Project 3', g.assignment_name
    assert_equal 95.5, g.score
    assert_equal 'A', g.grade
    assert_equal '2025-10-12T12:34:56Z', g.submitted_at
  end

  def test_initialize_with_missing_fields
    g = Grade.new({})
    assert_nil g.assignment_id
    assert_nil g.assignment_name
    assert_nil g.score
    assert_nil g.grade
    assert_nil g.submitted_at
  end

  def test_handles_empty_strings
    data = {
      'assignment_id' => 0,
      'name' => '',
      'score' => '',
      'grade' => '',
      'submitted_at' => ''
    }
    g = Grade.new(data)
    assert_equal 0, g.assignment_id
    assert_equal '', g.assignment_name
    assert_equal '', g.score
    assert_equal '', g.grade
    assert_equal '', g.submitted_at
  end

  def test_allows_assignment_name_mutation
    data = { 'assignment_id' => 7, 'name' => 'HW 1' }
    g = Grade.new(data)
    assert_equal 'HW 1', g.assignment_name
    g.assignment_name = 'Homework 1'
    assert_equal 'Homework 1', g.assignment_name
  end

  def test_preserves_raw_types
    # No coercion happens in the wrapper. Whatever the API provides is surfaced.
    data = { 'assignment_id' => '007', 'score' => '88', 'grade' => :Bplus }
    g = Grade.new(data)
    assert_equal '007', g.assignment_id
    assert_equal '88', g.score
    assert_equal :Bplus, g.grade
  end
end
