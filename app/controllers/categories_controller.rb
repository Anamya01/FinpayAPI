class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    categories = Category.all.page(params[:page]).per(params[:per_page] || 10)
    json_response(
      CategorySerializer.new(categories),
      :ok,
      nil,
      pagination_meta(categories)
    )
  end

  def show
    json_response(CategorySerializer.new(category))
  end

  def create
    new_category = Category.new(category_params)
    new_category.save!

    json_response(
      CategorySerializer.new(new_category).serialize,
      :created
    )
  end

  def update
    category.update!(category_params)
    json_response(CategorySerializer.new(category))
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
    error_response("Not authorized", :forbidden)
  end
end
