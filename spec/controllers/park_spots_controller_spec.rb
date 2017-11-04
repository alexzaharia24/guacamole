require "rails_helper"

RSpec.describe "park spots", :type => :request do
  fixtures :users, :park_spots
  def user_two_authenticated_header
    token = Knock::AuthToken.new(payload: {sub: users(:two).id}).token
    {
      'Authorization': "Beared #{token}"
    }
  end

  it "returns park spots for current user" do
    get '/user/park_spots',
        headers: user_two_authenticated_header
    assert_response :success
    resp_json = JSON.parse(response.body)
    expect(resp_json.length).to eq(1)
    expect(resp_json[0]['id']).to eq(2)
    expect(resp_json[0]['name']).to eq("Garaj_Beclean")
    expect(resp_json[0]['user_id']).to eq(2)
    expect(resp_json[0]['address']).to eq("Strada_Principala")
    expect(resp_json[0]['latitude']).to eq(1.5)
    expect(resp_json[0]['longitude']).to eq(1.5)
    expect(resp_json[0]['price_per_hour']).to eq(1.5)
    expect(resp_json[0]['size']).to eq("medium")
    expect(resp_json[0]['description']).to eq("0123456789" * 5)
  end
end
