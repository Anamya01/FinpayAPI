module Api
  module V1
    class CompaniesController < BaseController
      # GET /Companies
      def index
        json_response(data: Company.all)
      end
      # GET /companies/:id
      def show
        json_response(data: company)
      end
      # POST /Companies
      def create
        company = Company.create!(
          name: params[:name],
          subdomain: params[:subdomain]
        )
        CompanyProvisioningService.call(company, params[:email], params[:password])
        json_response(data: company, status: :created)
      end
      # PUT companies/:id
      def update
        company.update!(company_params)
        json_response(data: company, status: :ok)
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
  end
end
