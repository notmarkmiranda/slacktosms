class SlackConnectionsController < ApplicationController
  def show
    @slack_connection = current_user.slack_connections.find(params[:id])
    @channels = SlackService.channels(@slack_connection.team_id, @slack_connection.access_token)
    @existing_subscriptions = Subscription.where(slack_connection: @slack_connection).pluck(:channel_id)
  end

  def create_subscriptions
    @slack_connection = current_user.slack_connections.find(params[:id])
    selected_channel_ids = params[:channel_ids] || []
    channel_names = params[:channel_names] || {}

    # Fetch existing subscriptions for the current slack connection
    existing_channel_ids = Subscription.where(slack_connection: @slack_connection).pluck(:channel_id)

    # Determine which channels are new and which are removed
    new_channel_ids = selected_channel_ids - existing_channel_ids
    removed_channel_ids = existing_channel_ids - selected_channel_ids

    # Create subscriptions for new channels only
    new_channel_ids.each do |channel_id|
      Subscription.create(
        slack_connection: @slack_connection,
        channel_id: channel_id,
        channel_name: channel_names[channel_id]
      )
    end

    # Delete subscriptions for removed channels
    Subscription.where(slack_connection: @slack_connection, channel_id: removed_channel_ids).destroy_all

    redirect_to slack_connection_path(@slack_connection), notice: "Subscriptions updated successfully."
  end
end
