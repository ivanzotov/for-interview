require 'rails_helper'

include Surveymonkey

RSpec.describe Mapping::Scheme do
  it "returns instance with symbolized name and type" do
    scheme = Mapping::Scheme.new({
                                   name: "email",
                                   page_id: "123",
                                   question_id: "456",
                                   type: "text",
                                   params: {
                                     hello: "world"
                                   }
                                 })
    expect(scheme.name).to be(:email)
    expect(scheme.page_id).to eq("123")
    expect(scheme.question_id).to eq("456")
    expect(scheme.type).to be(:text)
    expect(scheme.params).to eq({ hello: "world" })
  end

  it "returns empty params by default" do
    scheme = Mapping::Scheme.new({
                                   name: "email",
                                   page_id: "123",
                                   question_id: "456",
                                   type: "text"
                                 })
    expect(scheme.params).to eq({})
  end
end