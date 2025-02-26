module AuthenticationHelpers
  def log_in_as(user)
    post login_path, params: { session: { email: user.email, password: 'password' } }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
