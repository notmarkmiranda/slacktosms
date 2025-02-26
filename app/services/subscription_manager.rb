class SubscriptionManager
  def initialize(slack_connection, selected_channel_ids, channel_names)
    @slack_connection = slack_connection
    @selected_channel_ids = selected_channel_ids || []
    @channel_names = channel_names || {}
  end

  def update_subscriptions
    existing_channel_ids = Subscription.where(slack_connection: @slack_connection).pluck(:channel_id)

    new_channel_ids = @selected_channel_ids - existing_channel_ids
    removed_channel_ids = existing_channel_ids - @selected_channel_ids

    create_new_subscriptions(new_channel_ids)
    remove_old_subscriptions(removed_channel_ids)
  end

  private

  def create_new_subscriptions(new_channel_ids)
    channels = new_channel_ids.map do |channel_id|
      Subscription.create(
        slack_connection: @slack_connection,
        channel_id: channel_id,
        channel_name: @channel_names[channel_id]
      )
    end

    channels.each_slice(45) do |batch|
      SlackService.get_last_message_ts(batch)
    end
  end

  def remove_old_subscriptions(removed_channel_ids)
    Subscription.where(slack_connection: @slack_connection, channel_id: removed_channel_ids).destroy_all
  end
end
