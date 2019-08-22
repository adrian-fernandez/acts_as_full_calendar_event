require "spec_helper"
require "byebug"

describe ActsAsFullCalendarEvent::FullCalendarEventSerializer do
  let!(:event1) { create(:event, start_at: Date.new(2018, 1, 1), end_at: Date.new(2018, 1, 31), category_id: 1, user_id: 1) }

  it "returns correct json" do
    serializer = ActsAsFullCalendarEvent::FullCalendarEventSerializer.new(event1)

    result = serializer.serializable_hash

    expect(result).to eq({
      id: 1,
      start: Date.new(2018, 1, 1),
      end: Date.new(2018, 1, 31),
      title: "title",
      description: "description",
      color: "#FF0000",
      textColor: "#AAFFBB",
      link_url: "URL",
      link_data_target: "#modal",
      link_data_toggle: "modal"
    })
  end
end
