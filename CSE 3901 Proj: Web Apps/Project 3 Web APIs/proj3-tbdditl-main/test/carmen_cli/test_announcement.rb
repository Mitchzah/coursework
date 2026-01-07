# frozen_string_literal: true

# Unit tests for the Announcement class.
# Validates initialization with various types of API response data,
# including nil, empty, HTML-only, and non-string messages.

require 'minitest/autorun'
require './lib/carmen_cli'

class TestAnnouncement < Minitest::Test
  def test_initialize_with_regular_data
    announcement_data_regular = {
      'id' => 123,
      'title' => 'Important Update',
      'message' => '<p>This is an <strong>important</strong> announcement!</p>',
      'posted_at' => '2025-10-01T12:00:00Z'
    }
    announcement = Announcement.new(announcement_data_regular)
    assert_equal announcement_data_regular['id'], announcement.id
    assert_equal announcement_data_regular['title'], announcement.title
    assert_equal 'This is an important announcement!', announcement.message
    assert_equal announcement_data_regular['message'], announcement.raw_message
    assert_equal announcement_data_regular['posted_at'], announcement.posted_at
  end

  def test_initialize_with_nil_message
    announcement_data_nil_message = {
      'id' => 124,
      'title' => 'Another Update',
      'message' => nil,
      'posted_at' => '2025-10-14T12:00:00Z'
    }
    announcement = Announcement.new(announcement_data_nil_message)
    assert_equal announcement_data_nil_message['id'], announcement.id
    assert_equal announcement_data_nil_message['title'], announcement.title
    assert_equal '', announcement.message
    assert_nil announcement.raw_message
    assert_equal announcement_data_nil_message['posted_at'], announcement.posted_at
  end

  def test_initialize_with_empty_message
    announcement_data_empty_message = {
      'id' => 125,
      'title' => 'Empty Message',
      'message' => '',
      'posted_at' => '2025-10-03T12:00:00Z'
    }
    announcement = Announcement.new(announcement_data_empty_message)
    assert_equal announcement_data_empty_message['id'], announcement.id
    assert_equal announcement_data_empty_message['title'], announcement.title
    assert_equal '', announcement.message
    assert_equal announcement_data_empty_message['message'], announcement.raw_message
    assert_equal announcement_data_empty_message['posted_at'], announcement.posted_at
  end

  def test_initialize_with_missing_fields
    announcement_data_missing_fields = {
      'id' => 126,
      'title' => 'Missing Fields'
      # 'message' and 'posted_at' are missing
    }
    announcement = Announcement.new(announcement_data_missing_fields)
    assert_equal announcement_data_missing_fields['id'], announcement.id
    assert_equal announcement_data_missing_fields['title'], announcement.title
    assert_equal '', announcement.message
    assert_nil announcement.raw_message
    assert_nil announcement.posted_at
  end

  def test_initialize_with_html_only_message
    announcement_data_html_only = {
      'id' => 127,
      'title' => 'HTML Only',
      'message' => '<div><span></span></div>',
      'posted_at' => '2025-10-05T12:00:00Z'
    }
    announcement = Announcement.new(announcement_data_html_only)
    assert_equal announcement_data_html_only['id'], announcement.id
    assert_equal announcement_data_html_only['title'], announcement.title
    assert_equal '', announcement.message
    assert_equal announcement_data_html_only['message'], announcement.raw_message
    assert_equal announcement_data_html_only['posted_at'], announcement.posted_at
  end
end
