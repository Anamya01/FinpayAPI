class CompaniesController < ApplicationController
  # GET /Companies
  def index
    json_response(Company.all)
  end
  # GET /companies/:id
  def show
    json_response(company)
  end
  # POST /Companies
  def create
    company = Company.create!(
      name: params[:name],
      subdomain: params[:subdomain]
    )
    CompanyProvisioningService.call(company, params[:email], params[:password])
    json_response(company, :created)
  end
  # PUT companies/:id
  def update
    company.update!(company_params)
    json_response(company, :ok)
  end
  # DELETE companies/:id
  def destroy
    company.destroy!
    head :no_content
  end
  private
  def company
    @company ||= Company.find(params[:id])
  end
  def company_params
    params.permit(:name)
  end
end
