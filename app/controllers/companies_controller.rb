class CompaniesController < ApplicationController
  def create
    company = Company.create!(
      name: params[:name],
      schema_name: "tenant_#{SecureRandom.hex(4)}"
    )

    CompanyProvisioningService.call(company)

    render json: company
  end
end