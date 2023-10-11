require 'rails_helper'

RSpec.describe Surveymonkey::Api do
  it "has response details url" do
    url = Surveymonkey::Api::RESPONSE_DETAILS % { survey_id: "123", id: "456" }
    expect(url).to eq("https://api.surveymonkey.net/v3/surveys/123/responses/456/details")
  end

  it "returns authorized connection" do
    connection = Surveymonkey::Api.authorized
    expect(connection).to be_a(Faraday::Connection)
  end
end