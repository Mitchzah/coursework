# frozen_string_literal: true

# This file defines the Announcement class, which represents
# a student-visible announcement fetched from an external API.
# It parses and cleans HTML messages into plain text for display.

# Simple Announcement class exposing student-visible announcement attributes.
class Announcement
  attr_reader :id,
              :title,
              :message,
              :posted_at,
              :raw_message

  # Creates a new Announcement from an API hash.
  def initialize(api_hash = {})
    @id = api_hash['id']
    @title = api_hash['title']
    @raw_message = api_hash['message']
    @message = strip_html(@raw_message.to_s)
    @posted_at = api_hash['posted_at']
  end

  private

  # A simple method to strip HTML tags from a string.
  def strip_html(html)
    text = html.gsub(/<[^>]+>/, '')
    # decode basic entities
    text = text.gsub('&nbsp;', ' ')
    text = text.gsub('&amp;', '&')
    text = text.gsub('&lt;', '<')
    text = text.gsub('&gt;', '>')
    # collapse whitespace
    text.strip.gsub(/\s+/, ' ')
  end
end
