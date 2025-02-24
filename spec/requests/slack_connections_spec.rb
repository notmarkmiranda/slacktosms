require 'rails_helper'

RSpec.describe "SlackConnections", type: :request do
  let(:user) { create(:user) }
  let(:slack_connection) { create(:slack_connection, user: user) }
  let(:existing_channel) { "C12345678" }
  let(:new_channel) { "C87654321" }
  let(:channel_names) { { existing_channel => "general", new_channel => "random" } }
  let(:channels) { [ { "id" => existing_channel, "name" => "general" }, { "id" => new_channel, "name" => "random" } ] }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(SlackService).to receive(:channels).and_return(channels)
    # Create an existing subscription
    create(:subscription, slack_connection: slack_connection, channel_id: existing_channel, channel_name: "general")
  end

  describe "POST /slack_connections/:id/create_subscriptions" do
    context "when adding new subscriptions" do
      it "creates new subscriptions for selected channels" do
        post create_subscriptions_slack_connection_path(slack_connection), params: {
          channel_ids: [ existing_channel, new_channel ],
          channel_names: channel_names
        }

        expect(response).to redirect_to(slack_connection_path(slack_connection))
        follow_redirect!

        expect(response.body).to include("Subscriptions updated successfully.")
        expect(slack_connection.subscriptions.pluck(:channel_id)).to include(new_channel)
      end
    end

    context "when removing subscriptions" do
      it "deletes subscriptions for unselected channels" do
        post create_subscriptions_slack_connection_path(slack_connection), params: {
          channel_ids: [ new_channel ], # existing_channel is not included
          channel_names: channel_names
        }

        expect(response).to redirect_to(slack_connection_path(slack_connection))
        follow_redirect!

        expect(response.body).to include("Subscriptions updated successfully.")
        expect(slack_connection.subscriptions.pluck(:channel_id)).not_to include(existing_channel)
      end
    end
  end
end
