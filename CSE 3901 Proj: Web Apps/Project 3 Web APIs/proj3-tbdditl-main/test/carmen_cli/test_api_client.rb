# frozen_string_literal: true

# Unit tests for CarmenCLI::CarmenAPIClient
# This test suite verifies the behavior of the CarmenAPIClient class,
# ensuring that methods for fetching courses, assignments, grades, calendar events,
# and announcements work correctly and return expected model instances.

require 'minitest/autorun'
require './lib/carmen_cli'

module CarmenCLI
  class TestApiClient < Minitest::Test
    def setup
      @client = CarmenCLI::CarmenAPIClient.new
    end

    def test_initialize
      assert_instance_of CarmenCLI::CarmenAPIClient, @client
    end

    def test_fetch_active_courses
      mock_response = [
        { 'id' => 1, 'name' => 'CSE 3901', 'start_at' => '2025-08-26', 'end_at' => '2025-12-18' },
        { 'id' => 2, 'name' => 'MATH 3345', 'start_at' => '2025-08-26', 'end_at' => '2025-12-18' }
      ]

      @client.stub :get, mock_response do
        courses = @client.fetch_active_courses
        assert_instance_of Array, courses
        assert_equal 2, courses.length
        courses.each do |course|
          assert_instance_of Course, course
          assert_respond_to course, :id
          assert_respond_to course, :name
          assert_respond_to course, :start_at
          assert_respond_to course, :end_at
        end
      end
    end

    def test_fetch_completed_courses
      mock_response = [
        { 'id' => 1, 'name' => 'CSE 2221', 'start_at' => '2024-08-20', 'end_at' => '2024-12-13' }
      ]

      @client.stub :get, mock_response do
        courses = @client.fetch_completed_courses
        assert_instance_of Array, courses
        assert_equal 1, courses.length
        courses.each do |course|
          assert_instance_of Course, course
          assert_respond_to course, :id
          assert_respond_to course, :name
          assert_respond_to course, :start_at
          assert_respond_to course, :end_at
        end
      end
    end

    def test_fetch_assignments_for_course
      mock_response = [
        { 'id' => 101, 'name' => 'Project 3', 'due_at' => '2025-10-15', 'course_id' => 1 },
        { 'id' => 102, 'name' => 'Project 3 Catme Survey', 'due_at' => '2025-10-15', 'course_id' => 1 }
      ]

      @client.stub :get, mock_response do
        assignments = @client.fetch_assignments_for_course(1)
        assert_instance_of Array, assignments
        assert_equal 2, assignments.length
        assignments.each do |assignment|
          assert_instance_of Assignment, assignment
          assert_respond_to assignment, :id
          assert_respond_to assignment, :name
          assert_respond_to assignment, :due_at
        end
      end
    end

    def test_fetch_assignments_for_active_courses
      mock_active_courses = [Course.new({ 'id' => 1, 'name' => 'CSE 3901' }),
                             Course.new({ 'id' => 2, 'name' => 'MATH 3345' })]

      course_assignments = {
        1 => [
          Assignment.new({ 'id' => 101, 'name' => 'Project 3', 'due_at' => '2025-10-15', 'course_id' => 1 }),
          Assignment.new({ 'id' => 102, 'name' => 'Homework 5', 'due_at' => '2025-10-16', 'course_id' => 1 })
        ],
        2 => [
          Assignment.new({ 'id' => 201, 'name' => 'Section 5 Exercises', 'due_at' => '2025-10-15', 'course_id' => 2 })
        ]
      }

      @client.stub :fetch_active_courses, mock_active_courses do
        @client.stub :fetch_assignments_for_course, ->(course_id) { course_assignments[course_id] } do
          assignments = @client.fetch_assignments_for_active_courses

          assert_instance_of Array, assignments
          assert_equal 3, assignments.length,
                       'Should have 3 assignments from Course 1 (2 assignments) and Course 2 (1 assignment)'

          # Verify structure
          assignments.each do |assignment|
            assert_instance_of Assignment, assignment
            assert_respond_to assignment, :id
            assert_respond_to assignment, :name
            assert_respond_to assignment, :due_at
            assert_respond_to assignment, :course_id
          end
        end
      end
    end

    def test_fetch_grades_for_course
      mock_submissions = [
        { 'id' => 1001, 'assignment_id' => 101, 'grade' => '95', 'submitted_at' => '2025-10-14T12:00:00Z' },
        { 'id' => 1002, 'assignment_id' => 102, 'grade' => '88', 'submitted_at' => '2025-10-15T12:00:00Z' }
      ]

      mock_assignment_names = {
        101 => 'Project 3',
        102 => 'Project 3 Catme Survey'
      }

      @client.stub :get, mock_submissions do
        @client.stub :assignment_names_for, mock_assignment_names do
          grades = @client.fetch_grades_for_course(1)
          assert_instance_of Array, grades
          assert_equal 2, grades.length
          grades.each do |grade|
            assert_instance_of Grade, grade
            assert_respond_to grade, :assignment_id
            assert_respond_to grade, :assignment_name
            assert_respond_to grade, :score
            assert_respond_to grade, :grade
            assert_respond_to grade, :submitted_at
          end
        end
      end
    end

    def test_fetch_my_calendar_events
      mock_response = [
        { 'id' => 1, 'title' => 'CSE 3901 Lecture', 'start_at' => '2025-10-15T10:00:00Z',
          'end_at' => '2025-10-15T11:00:00Z' },
        { 'id' => 2, 'title' => 'MATH 3345 Recitation', 'start_at' => '2025-10-16T14:00:00Z',
          'end_at' => '2025-10-16T15:00:00Z' }
      ]

      @client.stub :get, mock_response do
        events = @client.fetch_my_calendar_events
        assert_instance_of Array, events
        assert_equal 2, events.length
        events.each do |event|
          assert_instance_of CalendarEvent, event
          assert_respond_to event, :id
          assert_respond_to event, :title
          assert_respond_to event, :start_at
          assert_respond_to event, :end_at
        end
      end
    end

    def test_fetch_announcements
      mock_response = [
        { 'id' => 501, 'title' => 'Welcome to CSE 3901', 'message' => 'First class is on Aug 26!',
          'posted_at' => '2025-08-20T09:00:00Z' },
        { 'id' => 502, 'title' => 'Syllabus Posted', 'message' => 'Check the syllabus on the course page.',
          'posted_at' => '2025-08-21T10:00:00Z' }
      ]

      @client.stub :get, mock_response do
        announcements = @client.fetch_announcements(1)
        assert_instance_of Array, announcements
        assert_equal 2, announcements.length
        announcements.each do |announcement|
          assert_instance_of Announcement, announcement
          assert_respond_to announcement, :id
          assert_respond_to announcement, :title
          assert_respond_to announcement, :message
          assert_respond_to announcement, :posted_at
        end
      end
    end
  end
end
