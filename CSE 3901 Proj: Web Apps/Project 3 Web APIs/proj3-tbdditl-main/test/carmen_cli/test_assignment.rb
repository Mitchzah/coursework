# frozen_string_literal: true

# Unit tests for the Assignment class.
# Ensures that Assignment objects are correctly initialized from API hash data,
# including handling of regular data, missing fields, special characters, HTML content,
# and empty string values.

require 'minitest/autorun'
require './lib/carmen_cli'

class TestAssignment < Minitest::Test
  def test_initialize_with_regular_data
    assignment_data = {
      'id' => 101,
      'name' => 'Essay 1',
      'description' => '<p>Write about testing.</p>',
      'created_at' => '2025-09-20T10:00:00Z',
      'due_at' => '2025-09-27T23:59:00Z',
      'course_id' => 555
    }
    a = Assignment.new(assignment_data)
    assert_equal 101, a.id
    assert_equal 'Essay 1', a.name
    assert_equal '<p>Write about testing.</p>', a.description
    assert_equal '2025-09-20T10:00:00Z', a.created_at
    assert_equal '2025-09-27T23:59:00Z', a.due_at
    assert_equal 555, a.course_id
  end

  def test_initialize_with_missing_fields
    a = Assignment.new({})
    assert_nil a.id
    assert_nil a.name
    assert_nil a.description
    assert_nil a.created_at
    assert_nil a.due_at
    assert_nil a.course_id
  end

  def test_special_characters_and_html
    assignment_data = {
      'id' => 202,
      'name' => 'Résumé & Café',
      'description' => '<p>Use &amp; and &lt;tags&gt; properly.</p>',
      'created_at' => '2025-10-01T12:00:00Z',
      'due_at' => '2025-10-08T12:00:00Z',
      'course_id' => 777
    }
    a = Assignment.new(assignment_data)
    assert_equal 'Résumé & Café', a.name
    assert_equal '<p>Use &amp; and &lt;tags&gt; properly.</p>', a.description
  end

  def test_empty_strings_are_preserved
    assignment_data = {
      'id' => 0,
      'name' => '',
      'description' => '',
      'created_at' => '',
      'due_at' => '',
      'course_id' => ''
    }
    a = Assignment.new(assignment_data)
    assert_equal 0, a.id
    assert_equal '', a.name
    assert_equal '', a.description
    assert_equal '', a.created_at
    assert_equal '', a.due_at
    assert_equal '', a.course_id
  end
end
