# frozen_string_literal: true

require 'active_support/concern'

module ActsAsFullCalendarEvent
  module CalendarEvent
    extend ActiveSupport::Concern

    mattr_accessor :acts_as_full_calendar_event_options

    class_methods do
      def calendar_items
        self.public_send(acts_as_full_calendar_event_options[:method_fields])
      end

      def calendar_items_filter_by_category(category_id)
        self.public_send(acts_as_full_calendar_event_options[:method_filter_category], category_id)
      end

      def calendar_items_filter_by_user(user_id)
        self.public_send(acts_as_full_calendar_event_options[:method_filter_user], user_id)
      end

      def calendar_items_filter_by_date(start_date, end_date)
        self.public_send(acts_as_full_calendar_event_options[:method_filter_date], start_date, end_date)
      end

      def calendar_items_categories
        return [] unless self.respond_to?(acts_as_full_calendar_event_options[:method_categories])
        self.public_send(acts_as_full_calendar_event_options[:method_categories])
      end
    end

    def acts_as_full_calendar_event(args = {})
      calendar_class_args = %i[
        method_fields
        method_filter_category
        method_filter_user
        method_filter_date
        method_categories
        field_category_class
      ].freeze

      define_method :acts_as_full_calendar_event_options do
        self.class.instance_variable_get("@acts_as_full_calendar_event_options")
      end

      class_eval do
        @acts_as_full_calendar_event_options = { }.merge(args)

        def self.calendar_event?
          true
        end
      end

      class_args = args.select { |key, value| calendar_class_args.include?(key) }
      self.acts_as_full_calendar_event_options = { }.merge(class_args)
    end

    def calendar_item_start_at
      self.public_send(acts_as_full_calendar_event_options[:field_start])
    end

    def calendar_item_end_at
      self.public_send(acts_as_full_calendar_event_options[:field_end])
    end

    def calendar_item_title
      self.public_send(acts_as_full_calendar_event_options[:field_title])
    end

    def calendar_item_color
      self.public_send(acts_as_full_calendar_event_options[:field_color])
    end

    def calendar_item_text_color
      self.public_send(acts_as_full_calendar_event_options[:field_text_color])
    end

    def calendar_item_url
      self.public_send(acts_as_full_calendar_event_options[:field_url])
    end

    def calendar_item_link_data_toggle
      self.public_send(acts_as_full_calendar_event_options[:field_link_data_toggle])
    end

    def calendar_item_link_data_target
      self.public_send(acts_as_full_calendar_event_options[:field_link_data_target])
    end

    def calendar_category_class
      self.public_send(acts_as_full_calendar_event_options[:field_category_class])
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsFullCalendarEvent::CalendarEvent)
