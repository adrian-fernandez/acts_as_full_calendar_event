module ActsAsFullCalendarEvent
  class FullCalendarEventSerializer < ActiveModel::Serializer
    attributes(
      :id,
      :start,
      :end,
      :title,
      :description,
      :color,
      :textColor,
      :link_url,
      :link_data_toggle,
      :link_data_target
    )

    def start
      object.calendar_item_start_at
    end

    def end
      object.calendar_item_end_at
    end

    def title
      object.calendar_item_title
    end

    def description
      object.calendar_item_description
    end

    def color
      if object.calendar_item_color.present?
        object.calendar_item_color
      else
        ""
      end
    end

    def textColor
      if object.calendar_item_text_color.present?
        object.calendar_item_text_color
      else
        ""
      end
    end

    def link_url
      object.calendar_item_url
    end

    def link_data_target
      object.calendar_item_link_data_target
    end

    def link_data_toggle
      object.calendar_item_link_data_toggle
    end
  end
end