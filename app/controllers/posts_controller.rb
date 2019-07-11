class PostsController < ApplicationController

  before_action :destroy_not_exist_user_posts
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  helper_method :find_youtube

  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc)
  end

  def detailPost
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def create
    @post = Post.new(content: params[:content], user_id: session[:user_id])
    if @post.save
      if params[:image]
        @post.image_name = "#{@post.id}.jpg"
        image = params[:image]
        File.binwrite("public/post_image/#{@post.image_name}", image.read)
        @post.save
      end
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      @posts = Post.all.order(created_at: :desc)
      @post.content = params[:content]
      render("/posts/index")
    end
  end

  def editPost
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("/posts/editPost")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.image_name
      FileUtils.rm("public/post_image/#{@post.image_name}")
    end
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def destroy_not_exist_user_posts
    destroy_posts = Post.where(user_id: @destroy_user)
    destroy_posts.each do |post|
    post.destroy
    end
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

  def find_youtube(text)
    require 'uri'
    urls = URI.extract(text, ["http","https"])
    if urls.empty? == false
      urls.each do |url|
        if embed_url = url.gsub("https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/")
          return %Q{<iframe class="youtube-disp" title="YouTube video player" width="640" height="390" src="#{embed_url}" frameborder="0" allowfullscreen></iframe>}
        else
          return false
        end
      end   
    end
    return false
  end

  def follows
    @post = Post.new
    @user = User.find_by(id: params[:id])
    follows = Follow.where(user_id: @user.id)
    @posts = Post.where(user_id: [follows.pluck(:at_user_id)]).or(Post.where(user_id: @current_user.id)).order("created_at desc")
  end
end
