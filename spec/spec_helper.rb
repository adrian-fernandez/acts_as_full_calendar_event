# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")
require "sqlite3"
require "acts_as_full_calendar_event"
require "factory_bot"
require 'database_cleaner'
require "active_model_serializers"

# Dir["./spec/shared_example/**/*.rb"].sort.each { |f| require f }
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }
Dir["./spec/serializers/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define(version: 1) do
  create_table :categories do |t|
    t.string :name
  end

  create_table :other_categories do |t|
    t.string :name
  end

  create_table :events do |t|
    t.date :start_at
    t.date :end_at
    t.integer :user_id
    t.integer :category_id
  end

  create_table :other_events do |t|
    t.date :start_at
    t.date :end_at
    t.integer :user_id
    t.integer :other_category_id
  end
end

class Event < ActiveRecord::Base
  belongs_to :category

  acts_as_full_calendar_event field_start: :calendar_inicio,
    field_end: :calendar_fin,
    field_title: :calendar_title,
    field_description: :calendar_description,
    field_color: :calendar_color,
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

  def self.category_class
    Category
  end

  def self.categories
    Category.all
  end

  def self.for_calendario
    all
  end

  def self.within_calendar_category(category_id)
    where(category_id: category_id)
  end

  def self.by_user_id(user_id)
    where(user_id: user_id)
  end

  def self.filter_by_date(start_at, end_at)
    where("start_at >= ? AND end_at <= ?", start_at, end_at)
  end

  def calendar_inicio
    start_at
  end

  def calendar_fin
    end_at
  end

  def calendar_title
    "title"
  end

  def calendar_description
    "description"
  end

  def calendar_color
    "#FF0000"
  end

  def calendar_text_color
    "#AAFFBB"
  end

  def url_for_calendar
    "URL"
  end

  def calendar_link_data_toggle
    "modal"
  end

  def calendar_link_data_target
    "#modal"
  end
end

class OtherEvent < ActiveRecord::Base
  belongs_to :other_category

  acts_as_full_calendar_event field_start: :calendar_inicio,
    field_end: :calendar_fin,
    field_title: :calendar_title,
    field_description: :calendar_description,
    field_color: :calendar_color,
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

  def self.for_calendario
    all
  end

  def self.by_user_id(user_id)
    where(user_id: user_id)
  end

  def self.filter_by_date(start_at, end_at)
    where("start_at >= ? AND end_at <= ?", start_at, end_at)
  end

  def calendar_inicio
    start_at
  end

  def calendar_fin
    end_at
  end

  def calendar_title
    "title"
  end

  def calendar_description
    "description"
  end

  def calendar_color
    "#FF0000"
  end

  def calendar_text_color
    "#AAFFBB"
  end

  def url_for_calendar
    "URL"
  end

  def calendar_link_data_toggle
    "modal"
  end

  def calendar_link_data_target
    "#modal"
  end

  def self.category_class
    OtherCategory
  end

  def self.categories
    OtherCategory.all
  end

  def self.within_calendar_category(category_id)
    where(other_category_id: category_id)
  end
end

class Category < ActiveRecord::Base
end

class OtherCategory < ActiveRecord::Base
end