class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    categories = Category.all.page(params[:page]).per(params[:per_page] || 10)
    render json: { categories: CategorySerializer.new(categories),
                    meta: pagination_meta(categories) }
  end

  def show
    render json: CategorySerializer.new(category).serialize
  end

  def create
    new_category = Category.new(category_params)

    if new_category.save
      render json: CategorySerializer.new(new_category).serialize, status: :created
    else
      render json: { errors: new_category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if category.update(category_params)
      render json: CategorySerializer.new(category).serialize
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
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
    render json: { error: "Not authorized" }, status: :forbidden unless current_user.admin?
  end
end
