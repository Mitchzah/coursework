# frozen_string_literal: true

# Unit tests for the CalendarEvent class.
# Validates that CalendarEvent objects are correctly initialized from API hash data,
# including handling of complete data, missing fields, partial data, empty data,
# and unexpected data types.

require 'minitest/autorun'
require './lib/carmen_cli'

class TestCalendarEvent < Minitest::Test
  def test_event_creation_with_complete_data
    event_data = {
      'id' => 1,
      'title' => 'Board Meeting',
      'start_at' => '2025-10-10T09:00:00Z',
      'end_at' => '2025-10-10T11:00:00Z',
      'all_day' => false,
      'location_name' => 'Conference Room A',
      'location_address' => '123 Main St, Anytown, USA',
      'url' => 'http://example.com/event/1'

    }

    event = CalendarEvent.new(event_data)
    assert_equal event_data['id'], event.id
    assert_equal event_data['title'], event.title
    assert_equal event_data['start_at'], event.start_at
    assert_equal event_data['end_at'], event.end_at
    assert_equal event_data['all_day'], event.all_day
    assert_equal event_data['location_name'], event.location_name
    assert_equal event_data['location_address'], event.location_address
    assert_equal event_data['url'], event.url
  end

  def test_event_creation_with_missing_data
    event_data = {
      'id' => 2,
      'title' => 'Holiday',
      'start_at' => '2025-12-25T00:00:00Z',
      'end_at' => '2025-12-25T23:59:59Z',
      'all_day' => true
    }

    event = CalendarEvent.new(event_data)
    assert_equal event_data['id'], event.id
    assert_equal event_data['title'], event.title
    assert_equal event_data['start_at'], event.start_at
    assert_equal event_data['end_at'], event.end_at
    assert_equal event_data['all_day'], event.all_day
    assert_nil event.location_name
    assert_nil event.location_address
    assert_nil event.url
  end

  def test_event_creation_with_empty_data
    event_data = {}
    event = CalendarEvent.new(event_data)
    assert_nil event.id
    assert_nil event.title
    assert_nil event.start_at
    assert_nil event.end_at
    assert_nil event.all_day
    assert_nil event.location_name
    assert_nil event.location_address
    assert_nil event.url
  end

  def test_event_with_partial_data
    event_data = {
      'id' => 3,
      'title' => 'Team Lunch',
      'start_at' => '2025-11-15T12:00:00Z',
      'all_day' => false,
      'location_name' => 'Mikey Late Night Slice'
    }

    event = CalendarEvent.new(event_data)
    assert_equal event_data['id'], event.id
    assert_equal event_data['title'], event.title
    assert_equal event_data['start_at'], event.start_at
    assert_nil event.end_at
    assert_equal event_data['all_day'], event.all_day
    assert_equal event_data['location_name'], event.location_name
    assert_nil event.location_address
    assert_nil event.url
  end
end
