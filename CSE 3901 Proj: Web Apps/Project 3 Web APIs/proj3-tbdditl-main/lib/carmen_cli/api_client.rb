# frozen_string_literal: true

# This class provides a Ruby client interface for interacting with the Carmen API.
# It supports fetching courses, assignments, grades, calendar events, and announcements
# using authenticated HTTP requests.

# Environment Variables:
# - CARMEN_API_BASE_URL: Base URL of the Carmen API
# - CARMEN_API_ACCESS_TOKEN: Access token for authentication

require 'httpx'
require 'dotenv/load'
require 'uri'
require 'time'
require 'json'

module CarmenCLI
  # A class to handle API interactions with Carmen.
  class CarmenAPIClient
    def initialize
      # Check if the environment variables are set
      @base_url = ENV.fetch('CARMEN_API_BASE_URL', nil)
      @access_token = ENV.fetch('CARMEN_API_ACCESS_TOKEN', nil)

      raise 'CARMEN_API_BASE_URL is not set' if @base_url.nil?
      raise 'CARMEN_API_ACCESS_TOKEN is not set' if @access_token.nil?
    end

    # Add methods for API interactions starting here and ending at the 'private' section below.

    # Request only courses where the user has an active enrollment
    def fetch_active_courses
      response = get('courses', { enrollment_state: 'active' })
      build_models(response, Course)
    end

    # Request all courses (active + completed)
    def fetch_all_courses
      fetch_active_courses + fetch_completed_courses
    end

    # Request only courses where the user has a completed enrollment
    def fetch_completed_courses
      response = get('courses', { enrollment_state: 'completed' })
      build_models(response, Course)
    end

    # Request assignments for a specific course id
    def fetch_assignments_for_course(course_id)
      response = get("courses/#{course_id}/assignments", { bucket: 'upcoming' })
      build_models(response, Assignment)
    end

    # Request assignments for all active courses.
    def fetch_assignments_for_active_courses
      assignments = []
      fetch_active_courses.each do |course|
        assignments.concat(fetch_assignments_for_course(course.id))
      end
      assignments
    end

    # Request assignment names for a list of assignment ids in a specific course
    def assignment_names_for(course_id, ids)
      return {} if ids.empty?

      resp = get("courses/#{course_id}/assignments", { 'assignment_ids[]' => ids })
      Array(resp).each_with_object({}) { |a, h| h[a['id']] = a['name'] }
    end

    # Request grades (submissions) for a specific course id
    def fetch_grades_for_course(course_id)
      submissions = get("courses/#{course_id}/students/submissions")
      ids = submissions.map { |s| s['assignment_id'] }.compact.uniq
      id_to_name = assignment_names_for(course_id, ids)

      submissions.map do |s|
        s['name'] = id_to_name[s['assignment_id']]
        Grade.new(s)
      end
    end

    def fetch_my_calendar_events
      response = get('calendar_events',
                     { undated: true, all_events: true, start_date: Time.now.iso8601,
                       end_date: (Time.now + (60 * 60 * 24 * 30)).iso8601 })
      build_models(response, CalendarEvent)
    end

    # Fetch announcements for a specific course
    def fetch_announcements(course_id)
      context = ["course_#{course_id}"]
      response = get('announcements', { 'context_codes[]': context })
      build_models(response, Announcement)
    end

    private

    # Perform a GET request and accepts an optional params hash
    def get(path, params = {})
      url = "#{@base_url}/#{path}"
      url += "?#{URI.encode_www_form(params)}" if params&.any?

      response = HTTPX.get(url, headers: request_headers)
      parse_response(response)
    end

    # Perform a POST request
    def post(path, body = {})
      response = HTTPX.post("#{@base_url}/#{path}", body: body, headers: request_headers)
      parse_response(response)
    end

    # Standard headers used for all requests
    def request_headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      }
    end

    # Convert HTTPX response to parsed JSON.
    def parse_response(response)
      # Ensure we only attempt to parse successful responses
      return [] unless response.status&.between?(200, 299)

      body = response.to_s
      return [] if body.nil? || body.strip.empty?

      JSON.parse(body)
    end

    # Build model instances from an API response array.
    def build_models(response, klass)
      Array(response).map { |data| klass.new(data) }
    end
  end
end
