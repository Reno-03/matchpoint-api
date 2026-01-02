class JsonWebToken
  # Use Rails secret key base for encoding
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']

  # Encode a payload with expiration
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode a token
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0] # first element is payload
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
