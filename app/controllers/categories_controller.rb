class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_category, only: [:edit, :update, :destroy]
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    unless @category.destroy
      flash[:alert] = 'Category cannot be delete, because this category is being used in a post.'
    end
    redirect_to categories_path
  end

  private
  def authorize_admin
    redirect_to root_path, alert: 'Access Denied. You are not authorized to this path.' unless current_user.admin?
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
