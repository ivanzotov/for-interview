require 'rails_helper'

include Surveymonkey

RSpec.describe WebhookCallback do
  it "returns new instance from Action Parameters" do
    params = ActionController::Parameters.new()
    webhook_callback = WebhookCallback.from_action_parameters(params)
    expect(webhook_callback.is_a?(WebhookCallback))

    params = ActionController::Parameters.new({ name: "webhook" })
    webhook_callback = WebhookCallback.from_action_parameters(params)
    expect(webhook_callback.name).to eq("webhook")
  end

  it "is valid" do
    webhook_callback = WebhookCallback.new({
                                             name: "webhook",
                                             resources: {
                                               respondent_id: "123",
                                               survey_id: "456"
                                             }
                                           })
    expect(webhook_callback.valid?).to be_truthy

    webhook_callback = WebhookCallback.new({
                                             name: "webhook",
                                             something: "else",
                                             resources: {
                                               something: "else",
                                               respondent_id: "123",
                                               survey_id: "456"
                                             }
                                           })
    expect(webhook_callback.valid?).to be_truthy
  end

  it "is not valid" do
    webhook_callback = WebhookCallback.new({})
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("name must be present")

    webhook_callback = WebhookCallback.new({ name: "hello" })
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("resources must be present")

    webhook_callback = WebhookCallback.new({ name: "hello", resources: {} })
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("resources must be present")

    webhook_callback = WebhookCallback.new({ name: "hello", resources: true })
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("resources must be a hash")

    webhook_callback = WebhookCallback.new({ name: "hello", resources: { something: "else" } })
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("resources.respondent_id must be present")

    webhook_callback = WebhookCallback.new({
                                             name: "hello",
                                             resources: {
                                               respondent_id: "123"
                                             }
                                           })
    expect(webhook_callback.valid?).to be_falsy
    expect(webhook_callback.error).to eq("resources.survey_id must be present")
  end
end