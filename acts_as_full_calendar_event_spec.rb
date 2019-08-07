require "spec_helper"
require "byebug"

describe ActsAsFullCalendarEvent do
  it "adds methods" do
    expect(Event.respond_to?(:calendar_items)).to eq(true)
    expect(Event.respond_to?(:calendar_items_filter_by_category)).to eq(true)
    expect(Event.respond_to?(:calendar_items_filter_by_user)).to eq(true)
    expect(Event.respond_to?(:calendar_items_filter_by_date)).to eq(true)
    expect(Event.respond_to?(:calendar_items_categories)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_start_at)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_end_at)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_title)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_text_color)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_color)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_url)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_link_data_toggle)).to eq(true)
    expect(Event.new.respond_to?(:calendar_item_link_data_target)).to eq(true)
    expect(Event.new.respond_to?(:calendar_category_class)).to eq(true)
  end

  context "methods return value" do
    let!(:event1) { create(:event, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: 1, user_id: 1) }
    let!(:event2) { create(:event, start_at: Date.new(2018, 1, 15), end_at: Date.new(2018, 1, 31), category_id: 1, user_id: 2) }
    let!(:event3) { create(:event, start_at: Date.new(2018, 2, 1), end_at: Date.new(2018, 2, 2), category_id: 1, user_id: 2) }
    let!(:event4) { create(:event, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: 2, user_id: 2) }

    let!(:category) { create(:category, id: 1, name: "Category 1") }
    let!(:category2) { create(:category, id: 2, name: "Category 2") }
    let!(:category3) { create(:category, id: 3, name: "Category 3") }

    it "#calendar_items" do
      expect(Event.calendar_items).to eq([event1, event2, event3, event4])
    end

    it "#calendar_items_filter_by_category" do
      expect(Event.calendar_items_filter_by_category(1)).to eq([event1, event2, event3])
      expect(Event.calendar_items_filter_by_category(2)).to eq([event4])
    end

    it "#calendar_items_filter_by_user" do
      expect(Event.calendar_items_filter_by_user(1)).to eq([event1])
      expect(Event.calendar_items_filter_by_user(2)).to eq([event2, event3, event4])
    end

    it "#calendar_items_filter_by_date" do
      expect(Event.calendar_items_filter_by_date(Date.new(2018, 1, 1), Date.new(2018, 1, 31))).to eq([event1, event2, event4])
      expect(Event.calendar_items_filter_by_date(Date.new(2018, 1, 1), Date.new(2018, 2, 10))).to eq([event1, event2, event3, event4])
      expect(Event.calendar_items_filter_by_date(Date.new(2018, 1, 10), Date.new(2018, 2, 10))).to eq([event2, event3])
    end

    it "#calendar_items_categories" do
      expect(Event.calendar_items_categories.map(&:name)).to eq(["Category 1", "Category 2", "Category 3"])
    end

    it "#calendar_item_start_at" do
      expect(event1.calendar_item_start_at).to eq(Date.new(2018, 1, 1))
    end

    it "#calendar_item_end_at" do
      expect(event1.calendar_item_end_at).to eq(Date.new(2018, 1, 31))
    end

    it "#calendar_item_title" do
      expect(event1.calendar_item_title).to eq("title")
    end

    it "#calendar_item_color" do
      expect(event1.calendar_item_color).to eq("#FF0000")
    end

    it "#calendar_item_text_color" do
      expect(event1.calendar_item_text_color).to eq("#AAFFBB")
    end

    it "#calendar_item_url" do
      expect(event1.calendar_item_url).to eq("URL")
    end

    it "#calendar_item_link_data_toggle" do
      expect(event1.calendar_item_link_data_toggle).to eq("modal")
    end

    it "#calendar_item_link_data_target" do
      expect(event1.calendar_item_link_data_target).to eq("#modal")
    end

    it "#calendar_category_class" do
      expect(event1.calendar_category_class).to eq(Category)
    end
  end
end
