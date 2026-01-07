# frozen_string_literal: true

# Represents a calendar event returned from the Carmen API.
# This wrapper provides a read-only view of the event’s key attributes
# such as title, time range, location, and URL.

class CalendarEvent
  attr_reader :id,
              :title,
              :start_at,
              :end_at,
              :all_day,
              :location_name,
              :location_address,
              :url

  # Initialize a new CalendarEvent from Carmen API response data.             
  def initialize(api_hash = {})
    @id = api_hash['id']
    @title = api_hash['title']
    @start_at = api_hash['start_at']
    @end_at = api_hash['end_at']
    @all_day = api_hash['all_day']
    @location_name = api_hash['location_name']
    @location_address = api_hash['location_address']
    @url = api_hash['url']
  end
end
