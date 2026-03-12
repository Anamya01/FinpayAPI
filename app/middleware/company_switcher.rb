class CompanySwitcher
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    company_id = request.headers["X-Company-Id"]

    return @app.call(env) unless company_id

    company = Company.find(company_id)

    return [404, { "Content-Type" => "application/json" }, [{ error: "Company not found" }.to_json]] unless company

    Apartment::Tenant.switch(company.subdomain) do
      @app.call(env)
    end
  ensure
    Apartment::Tenant.reset
  end
end