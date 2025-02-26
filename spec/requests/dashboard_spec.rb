require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when the user is logged in" do
      before do
        sign_in user
      end

      it "renders the dashboard successfully" do
        get dashboard_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Dashboard")
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get dashboard_path

        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!

        expect(response.body).to include("Sign In or Sign Up")
      end
    end
  end
end
