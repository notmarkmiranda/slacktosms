require 'rails_helper'

RSpec.describe "Oauth", type: :request do
  let(:user) { create(:user) }
  let(:valid_oauth_response) do
    {
      "ok" => true,
      "access_token" => "xoxb-valid-token",
      "team" => { "id" => "T12345678", "name" => "Test Team" },
      "authed_user" => { "id" => "U12345678", "access_token" => "xoxb-valid-token" }
    }
  end
  let(:invalid_oauth_response) { { "ok" => false, "error" => "invalid_code" } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /slack/oauth/callback" do
    context "when the OAuth response is successful" do
      before do
        allow(SlackService).to receive(:oauth_access_token).and_return(valid_oauth_response)
      end

      it "creates a Slack connection and redirects to the dashboard with a success notice" do
        get slack_oauth_callback_path, params: { code: "valid_code" }

        expect(response).to redirect_to(dashboard_path)
        follow_redirect!

        expect(response.body).to include("Slack connected successfully")
        expect(SlackConnection.last).not_to be_nil
        expect(SlackConnection.last.team_name).to eq("Test Team")
      end
    end

    context "when the OAuth response is unsuccessful" do
      before do
        allow(SlackService).to receive(:oauth_access_token).and_return(invalid_oauth_response)
      end

      it "redirects to the dashboard with an alert" do
        get slack_oauth_callback_path, params: { code: "invalid_code" }

        expect(response).to redirect_to(dashboard_path)
        follow_redirect!

        expect(response.body).to include("Failed to connect Slack")
      end
    end
  end
end
