require 'rails_helper'

RSpec.describe SlackConnection, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:slack_user_id) }
    it { should validate_presence_of(:access_token) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe '#refresh_token' do
    xit 'refreshes the access token' do
      slack_connection = create(:slack_connection)
      # Assuming refresh_token is a method that updates the access token
      expect { slack_connection.refresh_token }.to change { slack_connection.access_token }
    end
  end

  describe '.create_from_oauth_response' do
    let(:user) { create(:user) }
    let(:valid_response) do
      {
        "ok" => true,
        "authed_user" => {
          "id" => "US9DEB406",
          "access_token" => "asdf"
        },
        "team" => {
          "id" => "TMB0N22U8",
          "name" => "wa-ffles"
        }
      }
    end

    it 'creates a SlackConnection from a valid response' do
      expect {
        SlackConnection.create_from_oauth_response(valid_response, user)
      }.to change(SlackConnection, :count).by(1)
    end

    it 'does not create a SlackConnection from an invalid response' do
      invalid_response = { "ok" => false }
      expect {
        SlackConnection.create_from_oauth_response(invalid_response, user)
      }.not_to change(SlackConnection, :count)
    end
  end
end
