require 'rails_helper'

RSpec.describe "Marketing", type: :request do
  describe "GET /" do
    it "renders the home page successfully" do
      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Stay in the loop with important Slack messages")
    end
  end
end
