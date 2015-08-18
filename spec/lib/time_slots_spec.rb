require "rails_helper"

describe TimeSlots do
  it "contains the objects from today" do
    one = double("one", created_at: Time.now)
    two = double("two", created_at: Time.now)
    three = double("three", created_at: 1.day.ago)

    slots = TimeSlots.new([one, two, three])

    expect(slots.today).to eq [one, two]
  end

  it "contains the objects from yesterday" do
    one = double("one", created_at: Time.now)
    two = double("two", created_at: 1.day.ago)

    slots = TimeSlots.new([one, two])

    expect(slots.yesterday).to eq [two]
  end

  it "contains the objects from last week" do
    a = double(created_at: Time.now)
    b = double(created_at: 1.day.ago)
    c = double(created_at: 2.days.ago)
    d = double(created_at: 7.days.ago)
    e = double(created_at: 1.week.ago)
    f = double(created_at: 8.days.ago)

    slots = TimeSlots.new([a,b,c,d,e,f])

    expect(slots.last_week).to eq [c,d,e]
  end

  it "contains the rest" do
    a = double("a", created_at: Time.now)
    b = double("b", created_at: 1.day.ago)
    c = double("c", created_at: 2.days.ago)
    d = double("d", created_at: 7.days.ago)
    e = double("e", created_at: 1.week.ago)
    f = double("f", created_at: 8.days.ago)
    g = double("g", created_at: 9.days.ago)
    h = double("h", created_at: 1.month.ago)

    slots = TimeSlots.new([a,b,c,d,e,f,g,h])

    expect(slots.older_than_one_week).to eq [f,g,h]
  end
end
