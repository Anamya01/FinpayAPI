class Rack::Attack
  # 1. Throttle: Login
  throttle("/login/ip", limit: 5, period: 60.seconds) do |req|
    if req.path == "/api/v1/login" && req.post?
      req.ip
    end
  end

  # 2. Throttle: API
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    if req.path.start_with?("/api/") && req.path != "/api/v1/login"
      req.ip
    end
  end

  # 3. Response Configuration
  self.throttled_response = lambda do |env|
    match_data = env["rack.attack.match_data"] || {}

    retry_after = match_data[:period] || 60
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [
        {
          error: "Too many requests. Please try again later.",
          retry_in: "#{retry_after} seconds"
        }.to_json
      ]
    ]
  end
end
