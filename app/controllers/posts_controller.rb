class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(user_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "Successfully created post!"
      redirect_to posts_path
    else
      flash.now[:danger] = "Could not create post."
      render 'new'
    end
  end

  def index
    @posts = Post.all
  end

  private

    def user_params
      params.require(:post).permit(:title, :body)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in to make a new post."
        redirect_to root_url
      end
    end
end
