# frozen_string_literal: true

# Command-line interface for interacting with the Carmen API.
# Provides commands to list courses, view assignments, check grades,
# see upcoming calendar events, and fetch course announcements.
#
# Requires environment variables:
# - CARMEN_API_BASE_URL
# - CARMEN_API_ACCESS_TOKEN

require 'thor'

module CarmenCLI
  # Simple command-line interface implementation.
  class CLI < Thor
    desc 'courses', 'List courses (active by default, use --past or --all for others)'
    option :all, type: :boolean, default: false, desc: 'Include all courses (past and active)'
    option :past, type: :boolean, default: false, desc: 'Show past (completed) courses'
    option :name, type: :string, desc: 'Filter courses by name (case-insensitive substring)'
    def courses
      # Prefer explicit options over positional argv parsing
      courses = if options[:all]
                  api.fetch_all_courses
                elsif options[:past]
                  api.fetch_completed_courses
                else
                  api.fetch_active_courses
                end

      courses = courses.select { |c| c.name.downcase.include?(options[:name].downcase) } if options[:name]
      puts_courses(courses, 'Your Courses:')
    end

    desc 'todo [course-id]', 'List upcoming assignments (for active courses or a specific course)'
    option :course_id, type: :string, desc: 'Specify a course ID to filter assignments'
    def todo
      assignments = if options[:course_id]
                      api.fetch_assignments_for_course(options[:course_id])
                    else
                      api.fetch_assignments_for_active_courses
                    end
      puts_todo(assignments, 'Your Upcoming Assignments:')
    end

    desc 'grades <course-id>', 'List grades for a specific course'
    option :course_id, type: :string, desc: 'Specify a course ID to view grades'
    def grades
      grade_collection = []
      if options[:course_id].nil?
        api.fetch_active_courses.each do |course|
          grades = api.fetch_grades_for_course(course.id)
          grade_collection += grades unless grades.empty?
        end
      else
        grade_collection += api.fetch_grades_for_course(options[:course_id])
      end
      puts_grades(grade_collection, 'Your Grades:')
    end

    desc 'calendar', 'List your upcoming calendar events'
    def calendar
      events = api.fetch_my_calendar_events
      puts 'Your Upcoming Calendar Events:'
      puts 'Event ID: Title (Start Date - End Date)'
      events.each do |event|
        puts "#{event.id}: #{event.title} (#{event.start_at} - #{event.end_at})"
      end
    end

    desc 'announcements <course-id>', 'List announcements for a specific course'
    option :course_id, type: :string, desc: 'Specify a course ID to view announcements'
    def announcements
      announcement_collection = []
      if options[:course_id].nil?
        api.fetch_active_courses.each do |course|
          announcements = api.fetch_announcements(course.id)
          announcement_collection += announcements unless announcements.empty?
        end
      else
        announcement_collection += api.fetch_announcements(options[:course_id])
      end
      puts_announcements(announcement_collection, 'Course Announcements:')
    end

    private

    # Instantiates CarmenCLI::CarmenAPIClient
    def api
      @api ||= begin
        CarmenCLI::CarmenAPIClient.new
      rescue StandardError => e
        abort "CarmenCLI: API client initialization failed: #{e.message}\nEnsure CARMEN_API_BASE_URL and CARMEN_API_ACCESS_TOKEN are set."
      end
    end

    def puts_courses(courses, header)
      puts header
      puts "#{'ID'.ljust(15)}Name"
      courses.each do |course|
        puts "#{course.id.to_s.ljust(15)}#{course.name}"
      end
    end

    def puts_todo(assignments, header)
      puts header
      puts "#{'Assignment ID'.ljust(20)}#{'Due Date'.ljust(25)}Assignment Name"
      assignments.each do |assignment|
        puts "#{assignment.id.to_s.ljust(20)}#{assignment.due_at.to_s.ljust(25)}#{assignment.name}"
      end
    end

    def puts_grades(grades, header)
      puts header
      puts "#{'ID'.ljust(10)}#{'Grade'.ljust(10)}Name"
      grades.each do |g|
        puts "#{g.assignment_id.to_s.ljust(10)}#{g.grade.to_s.ljust(10)}#{g.assignment_name}"
      end
    end

    def puts_announcements(announcements, header)
      puts header
      puts ' '
      announcements.each do |announcement|
        puts "#{announcement.title} (#{announcement.id}) | Posted at: #{announcement.posted_at}"
        puts announcement.message
        puts ' '
      end
    end
  end
end
