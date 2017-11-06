require 'rails_helper'

RSpec.describe "availabilities controller", :type => :request do
  fixtures :users, :park_spots, :availabilities

  def admin_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:admin).id}).token
    {'Authorization': "Beared #{token}"}
  end

  def user_two_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:two).id}).token
    {'Authorization': "Beared #{token}"}
  end

  it "returns http unauthenticated" do
    get "/availability/1"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns http unauthenticated" do
    patch "/availability/1"
    expect(response).to have_http_status(:unauthorized)
  end

  it "returns http unauthenticated" do
    delete "/availability/1"
    expect(response).to have_http_status(:unauthorized)
  end

  it "should return unauthorized for not admin or not owner" do
    delete '/availability/1',
        headers: user_two_authenticated_header
    expect(response).to have_http_status(:unauthorized)
  end

  it "should remove post of owner" do
    delete "/availability/2",
        headers: user_two_authenticated_header
    expect(response).to have_http_status(:success)
  end

  it "should remove post when admin" do
    delete "/availability/2",
        headers:  admin_authenticated_header
    expect(response).to have_http_status(:success)
  end

  it "returns http unauthenticated" do
    post '/availability'
    expect(response).to have_http_status(:unauthorized)
  end

  it "creats new availability to a park spot by user" do
    length = Availability.all.length
    post '/availability',
        headers: admin_authenticated_header,
        params: { :availability => { :park_spot_id => 1, :date => "2017-10-15",
            :start_time => "12:00", :end_time => "14:00" }}
    expect(response).to have_http_status(:success)
    expect(Availability.all.length).to eq(1 + length)
  end

  it "should patch update the availability when owner" do
    patch '/availability/1',
        headers: admin_authenticated_header,
        params: {
          availability: {
            date: "2017-01-01",
            start_time: "12:00",
            end_time: "14:00"
          }
        }
    expect(response).to have_http_status(:success)
  end

  it "should put update the availability when admin" do
    patch '/availability/1',
        headers: admin_authenticated_header,
        params: {
          availability: {
            date: "2017-01-01",
            start_time: "00:00",
            end_time: "02:00"
          }
        }
    av = Availability.find(1)
    expect(response).to have_http_status(:success)
    expect(av.date).to eq(Date.new(2017, 1, 1))
    expect(av.start_time.strftime("%H:%M")).to eq("00:00")
    expect(av.end_time.strftime("%H:%M")).to eq("02:00")
  end
end
