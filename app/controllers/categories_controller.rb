class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_category, only: [ :show, :update, :destroy ]

  def index
    categories = Category.all
    render json: CategorySerializer.new(categories).serialize
  end

  def show
    render json: CategorySerializer.new(@category).serialize
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: CategorySerializer.new(category).serialize, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: CategorySerializer.new(@category).serialize
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def require_admin
    render json: { error: "Not authorized" }, status: :forbidden unless current_user.admin?
  end
end
