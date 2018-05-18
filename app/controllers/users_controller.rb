class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    @hav_markers = @posts.where.not(latitude: nil, longitude: nil)
    @hash = Gmaps4rails.build_markers(@hav_markers) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.shop_name
      marker.json({title: post.address})
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザ登録しました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザ登録に失敗しました'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(post_params)
      flash[:success] = '投稿が更新されました'
      redirect_to @user
    else
      flash.now[:danger] = '投稿が更新されませんでした'
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
