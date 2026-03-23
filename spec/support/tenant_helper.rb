module TenantHelper
  def within_tenant(tenant = 'test', &block)
    Apartment::Tenant.switch(tenant, &block)
  end
end
