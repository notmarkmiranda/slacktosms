class TouchSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)
    response = HTTParty.post(
      "https://slack.com/api/conversations.history",
      query: {
        channel: subscription.channel_id,
        limit: 1
      },
      headers: {
        "Authorization" => "Bearer #{subscription.slack_connection.access_token}"
      }
    )
    parsed_response = response.parsed_response
    if parsed_response["ok"]
      subscription.update(last_seen_message_ts: parsed_response["messages"][0]["ts"])
    end
  end
end
