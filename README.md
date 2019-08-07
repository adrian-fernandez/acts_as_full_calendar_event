# Acts As Full Calendar Event
Gem to allow any model to work as event for FullCalendar

Acts As Full Calendar Event is a Ruby Gem specifically written for Rails/ActiveRecord models.
The main goals of this gem are:

- Allow any model to be used as event for [FullCalendar](https://fullcalendar.io/).
- Provide easy-to-use and reusable methods to perform searchs and filter data.
- Serialize data for calendar.

## Installation

### Supported Ruby and Rails versions

* Ruby >= 2.3.0
* Rails >= 4

### Install

Just add the following to your Gemfile to install the latest release.

```ruby
gem 'acts_as_full_calendar_event', '1.0.0'
```

And follow that up with a ``bundle install``.

## Usage

```ruby
class SomeEvent < ActiveRecord::Base
  acts_as_full_calendar_event field_start: :calendar_inicio,
    field_end: :calendar_fin,
    field_title: :calendar_title,
    field_color: "#FF0000",
    field_text_color: :calendar_text_color,
    field_url: :url_for_calendar,
    field_link_data_toggle: :calendar_link_data_toggle,
    field_link_data_target: :calendar_link_data_target,
    method_fields: :for_calendario,
    method_filter_category: :within_calendar_category,
    method_filter_user: :by_user_id,
    method_filter_date: :filter_by_date,
    method_categories: :categories,
    field_category_class: :category_class
end
```

### Calendar service

Initialize as
```ruby
ActsAsFullCalendarEvent::Calendar.new(params: params).filter
```

params is a hash that must contain:
· start (Date)
· end (Date)
and can also contain:
· user_id <Integer>
· Categories <Hash>

Categories hash has the following structure:

`{ "CategoryClassName1" => [id1, id2], "CategoryClassName2" => [id1, id2] }`

If some category class doesn't appear as hash key it will be ignored.

`filter` method returns an `ActiveRecord::Relation` with all matching events

## Testing

All tests follow the RSpec format and are located in the spec directory.
They can be run with:

```
rake spec
```

## License

Acts as votable is released under the [MIT
License](http://www.opensource.org/licenses/MIT).
