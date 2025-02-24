class Subscription < ApplicationRecord
  belongs_to :slack_connection

  validates :channel_id, presence: true
end
