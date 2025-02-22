require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a valid US phone number" do
    user = build(:user, phone_number: "1234567890")
    expect(user).not_to be_valid
    expect(user.errors[:phone_number]).to include("must be a valid US phone number")
  end
end
