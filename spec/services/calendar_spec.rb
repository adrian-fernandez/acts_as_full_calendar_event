require "spec_helper"
require "byebug"

describe ActsAsFullCalendarEvent::Calendar do
  describe "validates required attrs" do
    it "works with all params" do
      expect { ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          start: Date.new(2018, 1, 1),
          end: Date.new(2018, 1, 31),
          categories: { "1": 1 }
        }
      )}.not_to raise_error(ArgumentError)
    end

    it "requires start" do
      expect { ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          end: Date.new(2018, 1, 31),
          categories: { "1": 1 }
        }
      )}.to raise_error(ArgumentError)
    end

    it "requires end" do
      expect { ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          start: Date.new(2018, 1, 1),
          categories: { "1": 1 }
        }
      )}.to raise_error(ArgumentError)
    end

    it "doesn't require user_id" do
      expect { ActsAsFullCalendarEvent::Calendar.new(
        params: {
          start: Date.new(2018, 1, 1),
          end: Date.new(2018, 1, 31),
          categories: { "1": 1 }
        }
      )}.not_to raise_error(ArgumentError)
    end

    it "doesn't require categories" do
      expect { ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          start: Date.new(2018, 1, 11),
          end: Date.new(2018, 1, 31)
        }
      )}.not_to raise_error(ArgumentError)
    end
  end

  describe ".item_classes" do
    it "returns all classes having ActsAsFullCalendarEvent" do
      calendar = ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          start: Date.new(2018, 1, 1),
          end: Date.new(2018, 1, 31)
        }
      )

      klasses = calendar.send(:item_classes).map(&:to_s)
      expect(klasses.count).to eq(2)
      expect(klasses.include?("Event")).to be_truthy
      expect(klasses.include?("OtherEvent")).to be_truthy
    end
  end

  describe ".available_categories" do
    let!(:category) { create(:category, id: 1, name: "Category 1") }
    let!(:category2) { create(:category, id: 2, name: "Category 2") }
    let!(:category3) { create(:category, id: 3, name: "Category 3") }

    it "returns all categories" do
      calendar = ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: 1,
          start: Date.new(2018, 1, 1),
          end: Date.new(2018, 1, 31)
        }
      )

      categories = calendar.available_categories
      expect(categories).to eq([category, category2, category3])
    end
  end

  describe ".filter" do
    let!(:event1_user1_cat1) { create(:event, id: 1, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: category.id, user_id: 1) }
    let!(:event2_user1_cat2) { create(:event, id: 2, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: category2.id, user_id: 1) }
    let!(:event3_user1_cat2) { create(:event, id: 3, start_at: Date.new(2018, 2, 1), end_at: Date.new(2018, 2, 20), category_id: category2.id, user_id: 1) }
    let!(:event4_user2_cat1) { create(:event, id: 4, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: category.id, user_id: 2) }
    let!(:event5_user2_cat2) { create(:event, id: 5, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: category2.id, user_id: 2) }
    let!(:event6_user2_cat2) { create(:event, id: 6, start_at: Date.new(2018, 2, 1), end_at: Date.new(2018, 2, 20), category_id: category2.id, user_id: 2) }

    let!(:other_event1_user1_cat1) { create(:other_event, id: 11, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), other_category_id: other_category.id, user_id: 1) }
    let!(:other_event2_user1_cat2) { create(:other_event, id: 12, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), other_category_id: other_category2.id, user_id: 1) }
    let!(:other_event3_user1_cat2) { create(:other_event, id: 13, start_at: Date.new(2018, 2, 1), end_at: Date.new(2018, 2, 20), other_category_id: other_category2.id, user_id: 1) }
    let!(:other_event4_user2_cat1) { create(:other_event, id: 14, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), other_category_id: other_category.id, user_id: 2) }
    let!(:other_event5_user2_cat2) { create(:other_event, id: 15, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), other_category_id: other_category2.id, user_id: 2) }
    let!(:other_event6_user2_cat2) { create(:other_event, id: 16, start_at: Date.new(2018, 2, 1), end_at: Date.new(2018, 2, 20), other_category_id: other_category2.id, user_id: 2) }

    let!(:category) { create(:category, id: 1, name: "Category 1") }
    let!(:category2) { create(:category, id: 2, name: "Category 2") }
    let!(:category3) { create(:category, id: 3, name: "Category 3") }
    let!(:other_category) { create(:other_category, id: 1, name: "Other Category 1") }
    let!(:other_category2) { create(:other_category, id: 2, name: "Other Category 2") }
    let!(:other_category3) { create(:other_category, id: 3, name: "Other Category 3") }
    let(:calendar) do
      ActsAsFullCalendarEvent::Calendar.new(
        params: {
          user_id: user_id,
          start: start_date,
          end: end_date,
          categories: categories
        }
      )
    end

    context "with all filters" do
      let(:user_id) { 1 }
      let(:categories) { { "Category": [1], "OtherCategory": [2] }.to_json }

      context "with dates before all events" do
        let(:start_date) { Date.new(2017, 12, 1) }
        let(:end_date) { Date.new(2018, 1, 1) }

        it "doesn't return anything" do
          expect(calendar.filter).to eq([])
        end
      end

      context "with events in dates" do
        let(:start_date) { Date.new(2018, 1, 1) }
        let(:end_date) { Date.new(2018, 1, 31) }

        it "returns events" do
          expect(Event.all.count).to eq(6)
          expect(OtherEvent.all.count).to eq(6)
          expect(calendar.filter).to eq([
            event1_user1_cat1,
            other_event2_user1_cat2
          ])
        end
      end

      context "with dates after all events" do
        let(:start_date) { Date.new(2018, 1, 31) }
        let(:end_date) { Date.new(2018, 2, 10) }

        it "doesn't return anything" do
          expect(calendar.filter).to eq([])
        end
      end
    end

    context "without user_id" do
      let(:start_date) { Date.new(2018, 1, 1) }
      let(:end_date) { Date.new(2018, 1, 31) }
      let(:user_id) { nil }
      let(:categories) { { "Category": [1], "OtherCategory": [2] }.to_json }

      it "returns events for all users" do
        expect(calendar.filter).to eq([
          event1_user1_cat1,
          event4_user2_cat1,
          other_event2_user1_cat2,
          other_event5_user2_cat2
        ])
      end
    end

    context "without categories" do
      let(:start_date) { Date.new(2018, 1, 1) }
      let(:end_date) { Date.new(2018, 1, 31) }
      let(:user_id) { 1 }
      let(:categories) { nil }

      it "returns events for all categories" do
        expect(calendar.filter).to eq([
          event1_user1_cat1,
          event2_user1_cat2,
          other_event1_user1_cat1,
          other_event2_user1_cat2
        ])
      end
    end
  end
end
