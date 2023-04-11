class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # before_action :validate_post_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:categories, :user).all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      ip_address = request.remote_ip
    end
    @post.country = Geocoder.search(ip_address).first.country
    @post.country_code = Geocoder.search(ip_address).first.country_code
    @post.isp = Geocoder.search()
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

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    unless @post.destroy
      flash[:alert] = 'Cannot be delete, because this post has comments.'
    end
    redirect_to posts_path
  end

  private

  # def validate_post_owner
  #   unless @post.user == current_user
  #     flash[:notice] = 'the post not belongs to you'
  #     redirect_to posts_path
  #   end
  # end

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