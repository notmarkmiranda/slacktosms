class SlackService
  include HTTParty

  base_uri "https://slack.com/api"

  def self.oauth_access_token(code)
    response = post("/oauth.v2.access", body: {
      client_id: ENV["SLACK_CLIENT_ID"],
      client_secret: ENV["SLACK_CLIENT_SECRET"],
      code: code,
      redirect_uri: ENV["SLACK_REDIRECT_URI"]
    })
    response.parsed_response
  end
end
