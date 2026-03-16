class CompanyProvisioningService
  def self.call(company, email, password)
    schema = company.subdomain

    # create tenant schema
    Apartment::Tenant.create(schema)

    # run migrations inside tenant schema
    Apartment::Tenant.switch(schema) do
      migration_context = ActiveRecord::MigrationContext.new("db/migrate")
      migration_context.migrate

      # create admin user for this tenant
      User.create!(
        email: email,
        password: password,
        password_confirmation: password,
        role: :admin
      )
    end
  end
end
