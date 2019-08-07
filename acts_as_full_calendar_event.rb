# frozen_string_literal: true

require "active_record"
require "active_support/inflector"
require "active_model_serializers"

$LOAD_PATH.unshift(File.dirname(__FILE__))

module ActsAsFullCalendarEvent
  if defined?(ActiveRecord::Base)
    require "acts_as_full_calendar_event/calendar_event"
    require "acts_as_full_calendar_event/serializers/full_calendar_event_serializer"
    require "acts_as_full_calendar_event/services/calendar"

    ActiveRecord::Base.extend ActsAsFullCalendarEvent::CalendarEvent
  end
end
