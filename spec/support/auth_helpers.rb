module AuthHelpers
  def authenticated_header(user)
    # This manually encodes a JWT for the given user
    # using Devise-JWT configuration
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end
end
