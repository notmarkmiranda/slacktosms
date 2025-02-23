class OauthController < ApplicationController
  def callback
    response = SlackService.oauth_access_token(params[:code])
    if response["ok"]
      SlackConnection.create_from_oauth_response(response, current_user)
      redirect_to dashboard_path, notice: "Slack connected successfully"
    else
      redirect_to dashboard_path, alert: "Failed to connect Slack"
    end
  end
end
