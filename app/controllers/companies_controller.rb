class CompaniesController < ApplicationController
  # GET /Companies
  def index 
    render json: Company.all
  end
  # GET /companies/:id
  def show
    render json: company
  end 
  # POST /Companies
  def create
    company = Company.create!(
      name: params[:name],
      subdomain: params[:subdomain]
    )
    CompanyProvisioningService.call(company)
    render json: company
  end
  # PUT companies/:id
  def update
    company.update!(company_params)
    render json: company
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