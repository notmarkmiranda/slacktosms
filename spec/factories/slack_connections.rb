FactoryBot.define do
  factory :slack_connection do
    user
    slack_user_id { "US1DWE303" }
    access_token { "xoxp-asdf" }
    team_id { "TMB0S12F2" }
    team_name { "wa-ffles" }
  end
end
