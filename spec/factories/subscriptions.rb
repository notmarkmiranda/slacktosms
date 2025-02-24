FactoryBot.define do
  factory :subscription do
    slack_connection { nil }
    channel_id { "MyString" }
    channel_name { "MyString" }
    last_seen_message_ts { "MyString" }
    is_private { false }
    is_dm { false }
  end
end
