class SlackConnectionsController < ApplicationController
  def show
    @slack_connection = current_user.slack_connections.find(params[:id])
    @channels = SlackService.channels(@slack_connection.team_id, @slack_connection.access_token)
    @existing_subscriptions = Subscription.where(slack_connection: @slack_connection).pluck(:channel_id)
  end

  def create_subscriptions
    @slack_connection = current_user.slack_connections.find(params[:id])
    selected_channel_ids = params[:channel_ids]
    channel_names = params[:channel_names]

    SubscriptionManager.new(@slack_connection, selected_channel_ids, channel_names).update_subscriptions

    redirect_to slack_connection_path(@slack_connection), notice: "Subscriptions updated successfully."
  end
end
