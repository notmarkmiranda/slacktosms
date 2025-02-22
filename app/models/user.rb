class User < ApplicationRecord
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\+1\d{10}\z/, message: "must be a valid US phone number" }

  def generate_verification_code
    self.verification_code = rand(100_000..999_999).to_s
    self.verification_code_expires_at = 10.minutes.from_now
    save
  end

  def verify_phone_number(input_code)
    return false unless verification_code.present? && input_code.present?
    return false if verification_code_expires_at && verification_code_expires_at < Time.current
    if verification_code == input_code
      update(phone_verified: true)
      true
    else
      false
    end
  end
end
