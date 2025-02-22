require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do
    let(:user) { create(:user, phone_number: "1234567890") }

    context "with valid phone number" do
      it "redirects to the verification page" do
        post login_path, params: { phone_number: user.phone_number }
        expect(response).to redirect_to(/verify\/.+/)
        expect(flash[:notice]).to include("Verification code sent to #{user.phone_number}")
      end
    end

    context "with invalid phone number" do
      it "redirects to the login page with an error" do
        post login_path, params: { phone_number: "invalid" }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq("Something went wrong.")
      end
    end
  end

  describe "DELETE /logout" do
    it "logs the user out and redirects to the login page" do
      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
