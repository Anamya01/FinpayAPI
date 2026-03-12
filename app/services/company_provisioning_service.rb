class CompanyProvisioningService
  def self.call(company)
    schema = company.subdomain

    # create tenant schema
    Apartment::Tenant.create(schema)

    # run migrations inside tenant schema
    Apartment::Tenant.switch(schema) do
      migration_context = ActiveRecord::MigrationContext.new(
        "db/tenant_migrate")
      migration_context.migrate
    end
  end
end