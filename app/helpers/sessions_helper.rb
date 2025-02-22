module SessionsHelper
  def generate_secure_token(user)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
    verifier.generate({ user_id: user.id, expires_at: 1.hour.from_now.to_i })
  end

  def verify_secure_token(token)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
    data = verifier.verify(token)
    if data["expires_at"] > Time.current.to_i
      User.find(data["user_id"])
    else
      nil
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end
end
