class SlackConnection < ApplicationRecord
  belongs_to :user
  has_many :subscriptions, dependent: :destroy

  validates :slack_user_id, presence: true
  validates :access_token, presence: true
  validates :team_id, presence: true
  validates :team_name, presence: true

  validates :user_id, uniqueness: { scope: :team_id }

  def self.create_from_oauth_response(response, user)
    return unless response["ok"]

    authed_user = response["authed_user"]
    team = response["team"]
    create(
      slack_user_id: authed_user["id"],
      access_token: authed_user["access_token"],
      team_id: team["id"],
      team_name: team["name"],
      user: user
    )
  end
end
