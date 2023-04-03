class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :validate_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:categories, :user).all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def show; end
  def show
    # Find the post based on the short URL
    @post = Post.find_by(short_url: params[:short_url])
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @post.destroy
      flash[:alert] = 'Cannot be delete, because this post has comments.'
    end
      redirect_to posts_path
  end

  private

  def validate_post_owner
    unless @post.user == current_user
      flash[:notice] = 'the post not belongs to you'
      redirect_to posts_path
    end
  end

  # def set_post
  #   @post = Post.find(params[:id])
  # end
  def set_post
    # Find the post based on either the ID or the short URL
    if params[:id]
      @post = Post.find(params[:id])
    else
      @post = Post.find_by(short_url: params[:short_url])
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, :image, category_ids: [])
  end
end