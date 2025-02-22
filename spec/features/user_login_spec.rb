require 'rails_helper'

RSpec.feature "UserLogin", type: :feature do
  scenario "User logs in with a new phone number" do
    visit new_user_session_path

    fill_in "Phone Number", with: "1234567890"
    click_button "Submit"

    expect(page).to have_content("Verification code sent to 1234567890")

    # Simulate the user receiving the verification code
    user = User.find_by(phone_number: "1234567890")
    verification_code = user.verification_code

    # Visit the verification page (assuming this is the flow)
    visit verify_user_path(user)

    fill_in "Verification Code", with: verification_code
    click_button "Verify"

    # Check for successful login
    expect(page).to have_content("Verification successful. Welcome, 1234567890!")
  end
end
