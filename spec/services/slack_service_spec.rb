require 'rails_helper'

RSpec.describe SlackService, type: :service do
  describe '.oauth_access_token' do
    let(:code) { 'test_code' }
    let(:response_body) { { 'access_token' => 'xoxb-1234567890' }.to_json }
    let(:response) { instance_double(HTTParty::Response, parsed_response: JSON.parse(response_body)) }

    before do
      allow(SlackService).to receive(:post).and_return(response)
    end

    it 'requests an access token with the correct parameters' do
      expect(SlackService).to receive(:post).with("/oauth.v2.access", body: {
        client_id: ENV["SLACK_CLIENT_ID"],
        client_secret: ENV["SLACK_CLIENT_SECRET"],
        code: code,
        redirect_uri: ENV["SLACK_REDIRECT_URI"]
      }).and_return(response)

      SlackService.oauth_access_token(code)
    end

    it 'returns the parsed response' do
      result = SlackService.oauth_access_token(code)
      expect(result).to eq(JSON.parse(response_body))
    end
  end
end
