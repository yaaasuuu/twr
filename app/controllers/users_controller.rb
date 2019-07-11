class UsersController < ApplicationController

  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.profile = params[:profile]
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}",image.read)
    end
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/index")
    else
      render("users/edit")
    end
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(name: params[:name], account_name: params[:account_name],
      email: params[:email], password: params[:password],image_name: "default_user.jpg",profile: params[:profile])
    if @user.save
      session[:user_id] = @user.id
      flash[:noice] = "ユーザー登録が完了しました"
      redirect_to("/users/index")
    else
      render("/users/new")
    end
  end

  def login
    @user = User.find_by(account_name: params[:account_name],password:params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @account_name = params[:account_name]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def login_form
  end

  def destroy
    d_user = User.find_by(id: params[:id])
    d_posts = Post.where(user_id: d_user.id)

    #削除したアカウントの投稿とそれへのいいねを削除
    d_posts.each do |post|
      if like = Like.find_by(post_id: post.id)
        like.destroy
      end
      post.destroy
    end

    d_user.destroy
    redirect_to("/users/index")
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
       flash[:notice] = "権限がありません"
       redirect_to("/users/index")
    end
  end
  
  def follows
    @user = User.find_by(id: params[:id])
    @follows = Follow.where(user_id: @user.id)
  end

end
