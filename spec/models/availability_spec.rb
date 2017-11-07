require 'rails_helper'

RSpec.describe Availability, type: :model do
  it "should invalidate start time > end time" do
    a = Availability.new
    a.id = 1
    a.park_spot_id = 1
    a.date = Date.today
    a.start_time = Time.now
    a.end_time = Time.now - 2.days
    assert a.valid? == false
  end

  it "should invalidate start_time == end_time" do
    a = Availability.new
    a.id = 1
    a.park_spot_id = 1
    a.date = Date.today
    a.start_time = Time.now
    a.end_time = Time.now
    assert a.valid? == false
  end

  it "should invalidate intervals less than one hour" do
    a = Availability.new
    a.id = 1
    a.park_spot_id = 1
    a.date = Date.today
    a.start_time = Time.now
    a.end_time = Time.now + 59.minutes
    assert a.valid? == false
  end

  it "should validate a 1-hour interval availability" do
    a = Availability.new
    a.id = 1
    a.park_spot_id = 1
    a.date = Date.today
    a.start_time = Time.now
    a.end_time = Time.now + 1.hour
    assert a.valid?
  end
end
