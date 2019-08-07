module ActsAsFullCalendarEvent
  class Calendar
    attr_reader :user_id, :categories, :items, :start_date, :end_date
    private :user_id, :categories, :start_date, :end_date

    def initialize(params:)
      raise(ArgumentError, "params must include 'start' having a date value") if params[:start].blank? || params[:start].class != Date
      raise(ArgumentError, "params must include 'end' having a date value") if params[:end].blank? || params[:end].class != Date

      @user_id = params[:user_id] if params.has_key?(:user_id)
      @categories = JSON.parse(params[:categories] || '{}')
      @start_date = params[:start]
      @end_date = params[:end]
    end

    def filter
      @items = []

      item_classes.each do |item_class|
        items = item_class.calendar_items
        items = filter_by_category(items, item_class) if has_categories_filter?
        items = filter_by_date(items)
        items = filter_by_user(items) if has_user_filter?

        @items << items
      end

      items.flatten
    end

    def available_categories
      categories = []

      item_classes.each do |item_class|
        categories << item_class.calendar_items_categories
      end

      categories.flatten
    end

    private

    def filter_by_date(items)
      items.public_send(:calendar_items_filter_by_date, start_date, end_date)
    end

    def filter_by_category(items, item_class)
      if categories.has_key?(item_class.calendar_category_class.to_s)
        items.public_send(:calendar_items_filter_by_category, categories[item_class.calendar_category_class.to_s].split(",").flatten)
      else
        items
      end
    end

    def filter_by_user(items)
      items.public_send(:calendar_items_filter_by_user, user_id)
    end

    def item_classes
      ActiveRecord::Base.descendants.select do |c|
        c.respond_to?(:calendar_event?) && c.calendar_event?
      end.map(&:name).map(&:constantize)
    end

    def has_user_filter?
      user_id.present?
    end

    def has_categories_filter?
      categories.present? && categories != {}
    end
  end
end