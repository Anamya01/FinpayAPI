module Api
  module V1
    class CategoriesController < BaseController
      before_action :authenticate_user!
      before_action :require_admin

      def index
        categories = Category.all.page(params[:page]).per(params[:per_page] || 10)
        json_response(
          data: CategorySerializer.new(categories),
          message: nil,
          metadata: pagination_meta(categories)
        )
      end

      def show
        json_response(data: CategorySerializer.new(category))
      end

      def create
        new_category = Category.new(category_params)
        new_category.save!

        json_response(
          data: CategorySerializer.new(new_category),
          status: :created
        )
      end

      def update
        category.update!(category_params)
        json_response(data: CategorySerializer.new(category))
      end

      def destroy
        category.destroy
        head :no_content
      end

      private

      def category
        @category ||= Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description)
      end

      def require_admin
        return if current_user.admin?
        error_response(message: "Not authorized", status: :forbidden)
      end
    end
  end
end
