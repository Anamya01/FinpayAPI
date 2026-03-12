class CompaniesController < ApplicationController

  before_action :set_company, only: [:show, :update, :destroy]
  
  # GET /Companies
  def index 
    companies = Company.all
    render json: companies
  end

  # GET /companies/:id
  def show
    render json: @company
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
    @company.update!(company_params)
    render json: @company
  end 

  # DELETE companies/:id
  def destroy 
    @company.destroy!
    head :no_content
  end 

  private
  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.permit(:name)
  end

end