class CompanyProvisioningService
  def self.call(company)
    schema = company.schema_name

     # create schema
    Apartment::Tenant.create(schema)

    # run migrations in that schema
    Apartment::Tenant.switch(schema) do
      ActiveRecord::MigrationContext.new(
        "db/migrate",
        ActiveRecord::SchemaMigration
      ).migrate
    end
  end
end