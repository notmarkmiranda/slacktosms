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

  def self.channels(team_id, access_token)
    response = get(
      "/conversations.list",
      query: {
        team_id: team_id,
        types: "public_channel"
        # types: "public_channel,private_channel,mpim,im"
      },
      headers: {
        "Authorization" => "Bearer #{access_token}"
      }
    )
    response.parsed_response["channels"]
  end

  def self.get_last_message_ts(subscriptions)
    subscriptions.each do |subscription|
      TouchSubscriptionJob.perform_later(subscription.id)
    end
  end
end
